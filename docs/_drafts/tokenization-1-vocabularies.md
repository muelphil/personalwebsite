---
layout: post
title: "Tokenization: Vocabularies"
date:   2026-02-27 10:31:42 +0200
tags: [ "Computer Science", "Large Language Models" ]
read_time: 8
abstract: "Before a large language model can generate a single word, it needs to convert raw text into tokens. This post works through the design space of tokenization vocabularies, going from character-level extremes to word-level pitfalls, to build intuition for why modern models settle on subword tokenization."
short_abstract: "Working through the edge cases of vocabulary design to understand why modern LLMs use subword tokenization."
---

Understanding how large language models work is crucial — both for using them well and for researching them seriously.
This post covers the very first step in the processing chain of an LLM: tokenization.

## What Are Transformers, Really?

Transformers got their name from transforming one thing into another — text to image, image to text, speech to text,
text in one language to text in another. What makes this architecture so general is how it splits up input data into
processable chunks that can carry semantic meaning. Depending on the use case, these chunks might be pixel patches,
segments of a sound wave, or, in the case of text, words, subwords, or even single characters.

Large language models are built on this same architecture, and they are fundamentally *next-token predictors*. Given a
sequence of tokens, the model predicts the most likely next token based on context and learned internal representations
— and then the next, and the next after that.

<figure>
{% include posts/tokenization/autoregressive-llm.html
   start_tokens="Paris; is; the"
   inferred_tokens=" city; of; light;.;<|endoftext|>"
   speed="1" %}
<figcaption>Autoregressive inference: the LLM consumes all preceding tokens and generates one new token at a time. Each generated token is appended to the context before the next inference step.</figcaption>
</figure>

The first step on this journey is tokenization: splitting raw text into the chunks that can be fed to the LLM. This
post tries to build intuition for why different vocabulary sizes are chosen and why — from a logical reasoning
standpoint — splitting text into words and subwords makes sense. In the next post, we will go into the algorithm behind
most modern tokenizers today.

## Understanding the Sizes of Vocabularies

Before diving into the tradeoffs, it helps to establish some shared vocabulary (no pun intended):

- **Tokens** are the fundamental units of an LLM's generation. They can vary in length — in modern models they can
  represent single characters, subwords, or even whole words.
- **Subwords** are word fragments large enough to carry partial semantic meaning. The word `generalizability`, for
  instance, might be split into `general` and `izability` — both of which appear across many contexts and bring
  meaningful associations the model can build on.
- **Token IDs** are the integer indices that identify each token in the vocabulary. These are what actually get
  passed into the model: text comes in, gets tokenized, and becomes a sequence of integers that the model processes.
- **Vocabularies** are the complete set of all tokens a model knows about. Each entry has a corresponding learned
  embedding vector that carries its semantic representation.

Today, tokenizers are the only component trained *before* the otherwise end-to-end training pipelines of LLMs. Modern
LLMs typically have vocabulary sizes around 130,000 tokens. Deciding which tokens go into the vocabulary — and how
many — is far from trivial.

As a software engineer, I like to evaluate edge cases to get a full picture of the tradeoffs at play. Working through
the extremes is what helped me understand why researchers arrived at the algorithms and vocabulary sizes they did. So
let's start there.

### Using Characters (and Only Characters) as Tokens

A simple edge case would be to use the alphabet as a vocabulary — essentially the same idea as ASCII (American
Standard Code for Information Interchange), which was first developed to represent text as numbers for electronic
communication.

<figure>
{% include posts/tokenization/character-tokenization.html
   text="The quick brown fox jumps over the lazy dog"
   speed="1" %}
<figcaption>Character-level tokenization: each character becomes its own token. While maximally flexible, this results in very long sequences — here, 44 characters produce 44 tokens.</figcaption>
</figure>

This approach has one genuine advantage: a small vocabulary reduces computation. In the final step of next-token
prediction, the model computes a score — also called a *logit* — for every token in the vocabulary. It then applies a
*softmax*, a function that converts these arbitrary scores into a probability distribution, assigning higher
probability to higher-scoring tokens. Both the logit computation and the softmax scale with vocabulary size. Keeping
the vocabulary small saves real computation in these steps.

The problem is severe token inflation — one token per character. Because LLMs are autoregressive, every token requires
its own full forward pass through the model. The same amount of computation is expended regardless of whether a token
represents a single letter or an entire word. Generating a six-character word would therefore require six forward
passes instead of one, making this approach prohibitively expensive at scale.

There is also the problem of context size. LLMs are limited in how many tokens they can attend to at once. With
character-level tokens, the same amount of text consumes far more of that context budget, leaving less room for longer
inputs or richer reasoning.

An even more fundamental issue is that this approach conflicts with the goal of tokenization: to produce units that carry semantic meaning —
rich enough that the model can build useful representations around them. Single characters largely fail this test. The
letter `o` appears in `chocolate` and in `work`, but the two words have less in common than I would like them to. Without the surrounding
characters, there is almost nothing for the model to anchor a representation to.

### Using One Token for Every Single Word Imaginable

At the other extreme: why not generate all possible tokens by enumerating every character combination up to a certain
length from a base alphabet, effectively covering every word that could ever be written?

<figure>
{% include posts/tokenization/character-combinations.html
   alphabet="abcdefghijklmnopqrstuvwxyz"
   rows="4" %}
<figcaption>All possible tokens from character combinations of lengths 1–4. Even with just 26 letters, the vocabulary grows exponentially: 26 + 676 + 17,576 + 456,976 = 475,254 entries — before accounting for uppercase, digits, or punctuation.</figcaption>
</figure>

The problem is that this vocabulary explodes exponentially. Using only the 26 lowercase letters of the Roman alphabet,
all character combinations of up to five characters already yield over 12.3 million distinct tokens — roughly 100
times the vocabulary sizes used in modern LLMs, and that is before adding uppercase letters, digits, punctuation, or
any other language.

Beyond the sheer size, the vast majority of these tokens would carry no semantic meaning. The sequence `zxqbw` is a
valid combination, but there is nothing for a model to learn from it. A vocabulary saturated with meaningless entries
is not just wasteful — it actively crowds out the useful representations the model needs to build.

### Using One Token for Every Single Word

The next idea is more intuitive: take the training corpus, extract every distinct word, and assign each one a unique
token. This is the underlying idea behind many classical NLP systems — Bag of Words models, TF-IDF, Word2Vec and
GloVe embeddings, and early neural language models all worked roughly along these lines.

In theory, this sounds manageable. The [Oxford English Dictionary lists approximately 171,476 words currently in use](https://en.wikipedia.org/wiki/List_of_dictionaries_by_number_of_words).
In practice, the real number is far larger. Inflected word forms — conjugations and declensions like `play`,
`plays`, `playing`, `played` — are all distinct strings. Add neologisms, compound words, domain-specific
terminology, texts in multiple natural languages, and programming languages, and the vocabulary quickly becomes
enormous. Three distinct problems follow.

**Size and memory.** Every token in the vocabulary needs a corresponding embedding vector — a high-dimensional
representation learned during training. With a word-level vocabulary potentially numbering in the millions, the
embedding table alone becomes a substantial portion of the model's total parameter count, increasing both memory
requirements and inference cost.

**Rare words.** Including every word from a training corpus means including many that appear only a handful of times.
The model sees too few examples of these tokens to learn meaningful representations for them. Their embeddings remain
undertrained and noisy, contributing little to the model's capabilities.

**Out-of-vocabulary words.** Any word not seen during training — a new coining, evolving slang, a deliberate typo, or
a term from a new domain — has no token and therefore no representation. Tokenization simply breaks for inputs the
model was never trained to handle. This fragility is a fundamental limitation of purely word-level vocabularies.

### The Result: Subword Tokenization

The approach that modern tokenizers converge on is subword tokenization: splitting text into words and subword units
that are large enough to carry semantic meaning, while keeping the vocabulary to a manageable size.

The intuition is clean. If you know what a `book` is, and you know what a `store` is, then you already know what a
`bookstore` is — even if you have never encountered the compound before. Subword units allow the model to compose
meaning from parts, generalizing to new combinations of familiar pieces.

To ensure that tokenization never completely breaks — even on typos, novel words, or new emojis — all individual
bytes are included in the vocabulary as a fallback. This guarantees that any input string can always be tokenized,
regardless of what it contains.

{% capture info_text %}
**Try it yourself:**  You can experiment with [OpenAI’s tokenizer demo](https://platform.openai.com/tokenizer).
Try long technical terms from your field, deliberate typos, compound words or even emojis.
Notice how familiar chunks reappear across words. That repetition is not accidental, but what makes subword tokenization powerful.
{% endcapture %}
{% include info_block.html content=info_text %}

How to arrive at a good subword vocabulary algorithmically is the topic of the next post.

### Extra: Why Spaces Are Folded Into Tokens

When exploring the vocabularies of different LLMs, you will notice something: rather than a single space token, there
are many tokens that come in both a space-prefixed and a non-space-prefixed form. The word `man` and `▁man` (with a
leading space) are two distinct vocabulary entries with distinct token IDs.

<figure>
{% include posts/tokenization/vocabulary-spaces.html
   tokens="A| man| walked| past| a| snow|man"
   highlight="man| man" %}
<figcaption>Leading spaces are part of the token. <span class="token small"> man</span> and <span class="token small">man</span> are two distinct vocabulary entries with different token IDs — the tokenizer encodes the boundary between words directly into the token itself.</figcaption>
</figure>

The reasoning is practical. A standalone space character carries almost no semantic meaning on its own, but naively
including it as a separate token would roughly double the token count for most natural text — effectively halving how
much content fits in a fixed context window. Instead, the space is absorbed into the following token: `▁man` encodes
both the word boundary and the word itself in a single unit.

There is also a structural consequence for vocabulary construction: merging rules in LLM-oriented implementations
explicitly prohibit merging a token that ends before a space with one that begins with a space. This keeps word
boundaries legible in the vocabulary structure and prevents semantically incoherent merges that would blur where one
word ends and another begins.

## The Core Tradeoff Summarized

Tokenization is a balancing act between:

* **Computation** (smaller vocabularies are cheaper per step)
* **Sequence length** (larger tokens reduce the number of autoregressive steps)
* **Semantic richness** (tokens should carry meaningful structure)
* **Robustness** (any input must remain tokenizable)

Character-level tokenization optimizes vocabulary size but inflates sequence length.

Word-level tokenization shortens sequences but explodes vocabulary size and breaks on new words.

Subword tokenization strikes a compromise. Vocabulary sizes around 100k tokens turn out to be large enough to capture frequent patterns and small enough to keep computation manageable — while preserving compositional flexibility.

That compromise is not accidental. It emerges from an algorithmic process.

In the next post, we will look at how modern tokenizers actually _learn_ these subword units — and why the specific algorithms used today are surprisingly elegant.
