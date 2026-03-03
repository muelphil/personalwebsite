---
layout: post
title: "Tokenization"
date:   2026-02-27 10:31:42 +0200
---

# Tokenization

## Introduction

* understanding how language models work is crucial in using and researching them
* this post is to cover the first step in the processing chain of llms

* transformers got their name from transforming one thing to another -- text to image, image to text, speech to text,
  text in one language to text in another language
* they split up input data into processable chunks that can carry semantic meaning
* depending on the use case, this might be pixel patches, sound wave bits, or in the case of text words, subwords, or
  even single characters
* llms use this same architecture and are next token predictors, which means that given a sequence of such tokens, they
  predict the next token based on context and internal representations -- and then the next after that

![autogressive decoder animation]()

* the first step on this journey of generating the next token is tokenization -- splitting up the text in to chunks that
  can be fed to the llm
* this post tries to intuitively introduce tokenization

## Understanding the sizes of vocabularies

* `TODO`: what are vocabularies, what are tokens and token_ids, only step before end to end training
* modern LLMs have vocabulary sizes around 130k tokens
* Determining the size of vocabularies and which tokens go in is not trivial
* so before diving into the algorithm used to create vocabularies, lets first understand restrictions and goals
* as a software engineer I like to evaluate the edge cases in both what they provide and what they cost to get a full
  understanding of the tradeoffs at play and why researchers opted for the algorithms and vocabulary sizes they did

### Using characters (any only characters) as tokens

* A simple edge case would be to use the alphabet as a vocabulary -- basically the same Idea as American Standard Code
  for Information Interchange (ASCII), which was first used to represent text as numbers for exchanging them.

![character_vocab_illustration]()

* This would have one great advantage:
    * in the last step of the inference of the next token, the large language model computes a score, also called logit,
      for every token in the vocabulary.
    * Subsequently, it applies a softmax -- a function that turns a list of arbitrary values into a probability
      distribution, where probabilities are based on the size of the values (values that are higher than others also
      result in higher probabilities)
    * Both operations are dependent on the size of the vocabulary
    * keeping the vocabulary small, would save computation in these steps
* However, this would result in very high token inflation -- one token per character
    * this is super expensive, as LLMs are autoregressive and require the same amount of computation for one token, no
      matter if the token represents a full word or a single character.
    * generating a word made of 6 characters would take 6 times the forward passes when representing it using character
      tokens in comparison to representing it as a single token
    * a big problem in LLMs is that they are also limited in context size -- the size that determines how many tokens
      the llms can look back on
    * with the same context size but smaller tokens, this would also decrease the amount of text that could be fit into
      the context
* Also: the goal is to determine tokens for the vocabulary that represent semantic meaning
    * this allows for rich informed representations that the model can work with
    * single characters have no semantics outside their context:
    * there is an o in `chocolate`, but there is an o in `work` too, which have less in common than I would like them to
      have

### Using one token for every single word imaginable

* the other extreme would be representing every character combination there is as a token
* why not use one token for every single character combination imaginable by producing tokens based on all combinations
  up to a certain length based on an alphabet of base characters?

![character_combination_illustration]()

* reasoning: using only lower case roman alphabet (a-z), only including all character combinations for up to 5
  characters would
  already equal 12.3 million different tokens in the vocabulary -- 100x higher than the ~131k that you see as vocabulary
  sizes in most modern LLMs
* this would exponentially inflate the vocabulary size, also with many tokens that have no semantic meaning

### Using one token for every single word

* New plan: take the training corpus the language models are trained on, extract all words and use one token for every
  word found in the training corpus
    * (same idea as Bag of Words models, TF-IDF systems, Word2Vec and GloVe embeddings, Early neural language models)
* Oxford Dictionary lists approximately 171,476 english words in current
  use https://en.wikipedia.org/wiki/List_of_dictionaries_by_number_of_words
* the real number would be much larger, due to inflected variants (conjugations and declensions, e.g. break, breaks,
  breaking), word creations (also called neologisms), compound words, texts in different languages -- including
  programming languages
* although arguably lower than the previous edge case, this would still result in a vocabulary explosion, leading to
  several problems
* Size problem
    * In the next step, every token will be mapped to one embedding vector that will carry its semantic meaning
    * these embeddings vectors are learnt.
    * Large vocabulary sizes will therefore also result in large amounts of embedding vectors that need to be stored and
      loaded during inference
* Problem of learning semantic meaning for rare words
    * These vectors would also need to be learnt
    * Introducing a token for every word you can find will also lead to tokens that are very rare in the training data
    * this makes it hard for the model to infer semantic meaning for these words during training
* additionally, new words, that are not in the models training data would not be in the vocabulary (OOV (
  out-of-vocabulary))
    * would break the tokenization (no token exists for these words)
    * same goes for typos (although some are in the training data, deliberately left in, not every variation of typos
      are)
    * this would break tokenization

### Result: Using subwords

* text is split into words and subwords large enough to carry semantic meaning
* intuition: if you know what a `book` is, and you know what a `store` is, then you know what a `bookstore` is
* to make sure text can always be split up, all bytes are included as tokens, ensuring tokenization doesnt break under typos, new words or even new emojis
* how to get to a vocabulary like this will be discussed in the next post

### Extra: Why are spaces included in tokens, instead of one single space character

* When checking out the vocabularies of different LLMs, you will notice that spaces instead of there being just one
  space token, there are many tokens that exist without and with a preceding space, e.g. `man` and `▁man`

![space_tokenization_illustration]()

* spaces themselves would carry little semantic meaning, but inflate tokens (x2 in extreme cases)
* as a result, they are directly included in the tokens
* to enforce subwords as tokens, merging restrictions in LLM focused implementations prohibit merging tokens to the right on tokens that start with a space token.















## Practical Relevance of Tokenization
## Why tokenization matters in prompting and understanding what models do

* vocabulary
    * determines how much fits into context
    * affects model understanding -> Design Prompts With Tokenization In Mind
* some tasks are hard to handle for tokenizers -- i.e. character level manipulations
* Custom vocabularies for specific domains
    * such as code (Claude?)
* different tokenizers for different models -- do tokenizers for coding models tokenize differently?
* Pitfalls of rare words and tokenization in e.g. medical fields
* https://www.louisbouchard.ai/prompting-llms/
* effect of typos
### Extra: While all tokens can be represented via Byte-Level BPE, this does not mean the model might not generate invalid Unicode
* Extra: decoding may fail (see emoji combinations) -- just cause everything can be encoded, does not mean everything
  can be decoded valid in the utf-8 standard









#### Why `▁` represents a space in Sentencepiece






#### Why these characters specifically (see )

* TODO: reasoning for why `▁` and `Ġ` appear instead of spaces
* TODO








## Modern BPE-style tokenizers for LLMs

### Common changes across GPT / BERT / LLaMA-style models

#### 1) **Fixed vocabulary size**

* Training stops when `|V| = target_vocab_size`
* This replaces the “no frequent pair left” condition

#### 2) **Byte-level or Unicode-aware input**

* GPT-style: **byte-level BPE**
    * Input alphabet = 256 bytes
    * Guarantees _any_ string is representable
* BERT-style: Unicode normalization + chars

#### 3) **Corpus-wide merges (not per word)**

* Pairs counted across the entire corpus, not isolated words

#### 4) **Special tokens**

* `<BOS>`, `<EOS>`, `<PAD>`, `<UNK>`, `<MASK>`
* Often excluded from merge logic

#### 5) **Pre-tokenization**

* Regex-based splitting before BPE
* Example: whitespace, punctuation, digits handled separately

#### 6) **Efficiency-driven approximations**

* Pruned pair tracking
* Heuristics to avoid full recomputation each merge
* Parallelizable training






---

Perfect — I understand now. You want **bullet points that read like a mini blog**, explaining ideas step by step, with a slightly conversational/educational tone, while keeping the structure we agreed on:

Here’s a polished draft:

---

### Adaptation of Byte-Pair Encoding for Tokenization in LLMs

* BPE was originally designed for compressing text, but in LLMs, the **goal shifts**: we want a fixed-size vocabulary that efficiently represents the language, while still being able to handle any input text.
* The algorithm is largely the same, but some **key adjustments** make it work well for tokenization:

    * **Stop condition:** Instead of merging until no pair occurs more than once, training stops once the **vocabulary reaches a target size**. This ensures the model has a manageable number of tokens.
    * **Base units:** Tokenizers can start from either **bytes or characters**, rather than just characters, depending on the variant.
    * **Whitespace and control symbols:** Spaces, newlines, and other non-printable symbols need special handling so that merges remain unambiguous.
    * **Special tokens:** End-of-text, user/system markers, and other control tokens are added **after training**, separate from the learned merge list.
* Despite these changes, the **core BPE principles** remain:

    * Iteratively merge frequent adjacent units to build subwords.
    * Apply merges greedily during tokenization.
    * Frequency-aware representation: common sequences tend to become single tokens, rare sequences are split into smaller subwords.
* These adjustments allow BPE to efficiently tokenize massive corpora while still retaining the compression-inspired behavior that made the original algorithm so effective.

---

#### Byte-Level Byte-Pair Encoding (GPT-2)

* Introduced by Alec Radford et al. (2019) for **GPT-2**, byte-level BPE adapts the algorithm to work with **any UTF-8 text**, ensuring universal coverage.
* **Base alphabet:** 256 possible byte values; all input text is converted to bytes before tokenization.
* **Advantages:**
    * Any text, including emojis, foreign scripts, or unseen characters, can always be tokenized.
    * Vocabulary size can remain relatively small because bytes are the atomic units.
* GPT-style byte-level BPE remains simple, efficient, and fully compatible with the LLM’s frequency-aware subword representation.

---

#### SentencePiece BPE (Meta, Mistral, Qwen)
* SentencePiece is a language-independent tokenization framework developed at Google in 2018
* Implements both **Unigram LM** and **BPE** under one unified training pipeline
* SentencePiece BPE is used in models like Meta **LLaMA**, Mistral, and Alibaba **Qwen**, and starts from **Unicode characters** instead of bytes.
* **Base alphabet:** Unicode characters, which keeps the vocabulary **human-readable** and easy to inspect.
* **Whitespace handling:** Spaces are typically represented by a dedicated symbol (e.g., `_`) instead of a byte-mapped prefix.
* **Vocabulary size:** Generally larger than byte-level BPE for equivalent coverage because characters cover fewer sequences than bytes.
* **Coverage:** Most text can be tokenized, but rare or unseen characters may require a fallback token (e.g., `<unk>`), unlike byte-level BPE which guarantees coverage.
* SentencePiece BPE trades off **absolute universality** for readability and slightly more natural alignment with words in human languages.

