---
layout: post
title: "From Text to Tokens: The Balancing Act Behind LLM Vocabularies"
date: 2026-02-27 10:31:42 +0200
title_image: 'tokenization/title_image_tokenization_1'
tags: [ "Computer Science", "Large Language Models" ]
read_time: 8
abstract: "Before a large language model can generate a single word, it needs to convert raw text into tokens. This post works through the design space of tokenization vocabularies, going from character-level extremes to word-level pitfalls, to build intuition for why modern models settle on subword tokenization."
short_abstract: "Working through the edge cases of vocabulary design to understand why modern LLMs use subword tokenization."
---

Understanding how large language models work is crucial for both effective use and research.
This post covers the very first step in the processing chain of an LLM: tokenization.

## What Are Transformers, Really?

Transformers are named for their ability to transform one type of data into another. While originally designed to
translate text in one language into another, they were quickly adapted to solve all kinds of transformations: text to
image, image to text, speech to text. What makes this architecture so general is how it splits up input data into
processable chunks that can carry semantic meaning. Depending on the use case, these chunks might be pixel patches,
segments of a sound wave, or -- in the case of text -- words, subwords, or even single characters.

Large language models are built on this same architecture. Fundamentally, they are *next-token predictors*: given a
sequence of tokens, the model predicts the most likely next token based on context and learned internal representations,
one after another.

<figure>
{% include posts/tokenization/autoregressive-llm.html
   start_tokens="Paris; is; the"
   inferred_tokens=" city; of; light;.;<endoftext>"
   speed="1" %}
<figcaption>
Autoregressive inference: the model processes a sequence of tokens and predicts the next token at each step. After each prediction, the newly generated token is appended to the sequence and fed back into the model as part of the context for the next forward pass. The visualization shows both the textual tokens and their corresponding integer token IDs (bottom right).
</figcaption>
</figure>

The first step on this journey is tokenization: splitting raw text into the chunks that can be fed to the LLM. This post
builds intuition for the tradeoffs of different vocabulary structures and sizes from first principles. In the next one,
we will see how the frequency-based compression algorithms used in modern tokenizers arrive at a remarkably similar
solution through statistical optimization.

## Understanding the Sizes of Vocabularies

Before diving into the tradeoffs, it helps to establish some shared vocabulary (no pun intended):

* **Tokens** are the discrete units a language model processes and predicts. In text models, a token might be a single
  character, part of a word, or an entire word, depending on how the tokenizer splits the input.
* **Subwords** are common fragments of words learned from patterns in the training data, many of them aligning with
  meaningful parts like prefixes or suffixes. For example, `ability` is a subword that may be used in the construction
  of `applicability` and `generalizability`. Subwords appear in many words and help the model understand new
  combinations.
* **Token IDs** are the unique numerical identifiers for each token in the vocabulary. After tokenization, the model
  works with these IDs, which identify the token regardless of whether it represents a character, subword, or whole
  word.
* **Vocabulary** is the complete set of tokens a model knows.

The goal of tokenization is to produce discrete units that carry semantic meaning. Later, these meanings are captured by
learned vectors of fixed size, called embeddings. After tokenization and embedding, most of the computation an LLM
performs to predict the next token operates on these embeddings.

Today, tokenizers are the only components trained independently *before* the otherwise end-to-end training pipelines of
LLMs. Modern models use vocabularies ranging from tens of thousands of tokens to several hundred thousand in
multilingual settings. As an
example, [Llama-3.1-70B supports 7 languages and has a vocabulary size of 128.000](https://ai.meta.com/blog/meta-llama-3/).
Deciding which tokens go into the vocabulary (and how many) is far from trivial.

As a software engineer, I like to evaluate edge cases to get a full picture of the tradeoffs at play. Working through
the extremes is what really helped me understand why researchers chose the tokenization algorithms and vocabulary sizes
most common in modern LLMs. So let's start there.

### Using Characters (and Only Characters) as Tokens

A simple edge case would be to use the alphabet as a vocabulary; essentially the same idea as ASCII (American
Standard Code for Information Interchange), which was first developed to represent text as numbers for electronic
communication.

<figure>
{% include posts/tokenization/character-tokenization.html
   text="I love chocolate cookies at work."
%}
<figcaption>Character-level tokenization: each character becomes its own token. While maximally flexible, this results in very long sequences. Here, 25 characters produce 25 tokens.</figcaption>
</figure>

This approach has one genuine advantage: a small vocabulary reduces computation. In the final step of next-token
prediction, the model computes a score (also called a *logit*) for every token in the vocabulary. It then applies a
*softmax*, a function that converts these arbitrary scores into a probability distribution, assigning higher
probability to higher-scoring tokens. Both the logit computation and the softmax scale with vocabulary size. Keeping
the vocabulary small saves real computation in these steps.

The problem is severe token inflation: one token per character. Because LLMs are autoregressive, every token requires
its own full forward pass through the model. The same amount of computation is expended regardless of whether the
generated token
represents a single letter or an entire word. Generating a six-character word would therefore require six forward
passes instead of one, making this approach prohibitively expensive at scale.

There is also the problem of context size. LLMs are limited in how many tokens they can attend to at once. With
character-level tokens, the same amount of text consumes far more of that context budget, leaving less room for longer
inputs or richer reasoning.

An even more fundamental issue is that this approach conflicts with the goal of tokenization: to produce units that
carry semantic meaning,
rich enough that the model can build useful representations around them. Single characters largely fail this test. The
letter `o` appears in `chocolate` and in `work`, but the two words have less in common than I would like them to.
Without the surrounding
characters, there is almost nothing for the model to deduce meaningful representations from.

### Using One Token for Every Single Word Imaginable

At the other extreme: why not generate all possible tokens by enumerating every character combination up to a certain
length from a base alphabet, effectively covering every word that could ever be written?

<figure>
{% include posts/tokenization/character-combinations.html
   alphabet="abcdefghijklmnopqrstuvwxyz"
   rows="4" %}
<figcaption>All possible tokens from character combinations of lengths 1–4. Even with just 26 letters, the vocabulary grows exponentially: 26 + 676 + 17,576 + 456,976 = 475,254 entries.</figcaption>
</figure>

The problem is that this vocabulary explodes exponentially. Using only the 26 lowercase letters of the Roman alphabet,
all character combinations of up to five characters already yield over 12.3 million distinct tokens. That's roughly 100
times the vocabulary sizes used in modern LLMs, and that is before adding uppercase letters, digits, punctuation,
any other language or longer words.

Beyond the sheer size, the vast majority of these tokens would carry no semantic meaning. The sequence `zxqbw` is a
valid combination, but there is nothing for a model to learn from it. A vocabulary saturated with meaningless entries
is not just wasteful; it actively crowds out the useful representations the model needs to build.

### Using One Token for Every Single Word

The next idea is more intuitive: take the training corpus, extract every distinct word, and assign each one a unique
token. This is the underlying idea behind many classical NLP systems: Bag of Words models, TF-IDF, Word2Vec and
GloVe embeddings. Early neural language models all worked roughly along these lines.

The [Oxford English Dictionary lists approximately 171,476 words currently in use](https://en.wikipedia.org/wiki/List_of_dictionaries_by_number_of_words).
In theory, this sounds manageable.
In practice, the real number is far larger. Add inflected word forms (`play`,
`plays`, `playing`, `played`), neologisms, compound words, domain-specific
terminology, other natural languages, and programming languages, and the vocabulary quickly becomes enormous.

Three distinct problems follow.

**Size and memory.** During training, for every token in the vocabulary the model learns a high dimensional vector
capturing the semantic meaning of the token. If the vocabulary grows into the millions, the model’s embedding and output
projection matrices (which convert between token IDs and embedding vectors) becomes enormous.

**Rare words.** Including every word from a training corpus means including many that appear only a handful of times.
The model sees too few examples of these tokens to learn meaningful representations for them. Their embeddings remain
undertrained and noisy, contributing little to the model's capabilities.

**Out-of-vocabulary words.** Any word not seen during training has no token. Be it a simple typo or a woman descending
from the sky trying to type `supercalifragilisticexpialidocious` -- tokenization simply breaks for inputs the model was
never trained to handle.

### The Result: Subword Tokenization

The approach that modern tokenizers converge on is subword tokenization: splitting text into words and subword units
that are large enough to carry semantic meaning, while keeping the vocabulary to a manageable size.

The intuition is clean. If you know what a `book` is, and you know what a `store` is, then you already know what a
`bookstore` is, even if you have never encountered the compound before. Subword units allow the model to compose
meaning from parts, generalizing to new combinations of familiar pieces.

To ensure that tokenization never completely breaks (even on novel words, typos, or new emojis) modern tokenizers
include all individual
bytes in the vocabulary as a fallback. This guarantees that any input string can always be tokenized,
regardless of what it contains.

{% capture info_text %}
**Try it yourself:**  You can experiment with [OpenAI’s Online Tokenizer](https://platform.openai.com/tokenizer).
Try long technical terms from your field, deliberate typos, compound words, capitalization or even emojis.
Notice how familiar chunks reappear across words. That repetition is not accidental, but what makes subword tokenization
powerful.
{% endcapture %}
{% include info_block.html content=info_text %}

### Extra: Why Spaces Are Folded Into Tokens

When exploring the vocabularies of different LLMs, you will notice something: rather than a single space token, there
are many tokens that come in both a space-prefixed and a non-space-prefixed form. The word `man` and `▁man` (with a
leading space) are two distinct vocabulary entries with distinct token IDs.

<figure>
{% include posts/tokenization/vocabulary-spaces.html
   tokens="A| man| walked| past| a| snow|man"
   highlight="man| man" %}
<figcaption>Leading spaces are part of the token. <span class="token small"> man</span> and <span class="token small">man</span> are two distinct vocabulary entries with different token IDs. The tokenizer encodes the boundary between words directly into the token itself.</figcaption>
</figure>

The reasoning is practical. A standalone space character carries almost no semantic meaning on its own, but naively
including it as a separate token would roughly double the token count for most natural text, slowing down inference and
cluttering up the context window that is fixed to a certain token count. Instead, the space is absorbed into a new
token: `▁man` encodes
both the word boundary and the word itself in a single unit, as a separate token.

There is also a structural consequence for vocabulary construction: merging rules in most LLM-oriented implementations
explicitly prohibit merges that result in tokens containing spaces at the end or in the middle of a word. This keeps
word
boundaries legible in the vocabulary structure and prevents semantically incoherent merges that would blur where one
word ends and another begins.

## The Core Tradeoff

Tokenization sits at the intersection of three competing pressures:

* **Vocabulary size**  
  Larger vocabularies increase memory and output-layer computation.
* **Sequence length**  
  Smaller tokens increase the number of forward passes and consume context window capacity.
* **Semantic coherence**  
  Tokens should carry enough meaning to support useful internal representations.

Character-level tokenization minimizes vocabulary size but explodes sequence length.  
Word-level tokenization minimizes sequence length but explodes vocabulary size and breaks on new words.  
Subword tokenization balances both while preserving compositional meaning.

While we have now deduced the logic behind subword tokenization, vocabularies are not handpicked (that would be way too
much work). Instead, good subwords emerge from an algorithmic process based on the frequencies in the training data.

In the next post, we will look at how modern tokenizers actually _learn_ these subword units and why the specific
algorithms used today are surprisingly elegant.
