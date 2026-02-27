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

## How are vocabularies built

Following the previous post, that discussed advantages and restrictions of different vocabulary sizes and shapes, we will now look into one of the most popular algorithms modern tokenizers are based on.
among the several different approaches that exist (WordPiece, Unigram LM (Sentencepiece)), the one that put through
are algorithms that are based on [Byte-Pair Encoding](https://en.wikipedia.org/wiki/Byte-pair_encoding)
This will cover how tokenizers based on BPE are trained on the training corpus and how they will eventually after training tokenize unseen text.

To enhance learning, I have built an interactive demo of the training process. By default, it shows the version of the algorithm adjusted to be more representative of how the algorithm is now implemented for LLM tokenizers as opposed to the original one, but you can still apply original restrictions in the settings.

{% include link_block.html
image="tokenization/bpe-visualizer"
title="Byte Pair Encoding Visualizer - Interactive Algorithm Demo"
text="Step-by-step visualization of the Byte Pair Encoding (BPE) algorithm used for compressing data and building vocabularies for LLMs."
url="https://philipmueller.dev/bpe-visualization/
"
%}

### Byte-Pair Encoding (BPE, also Compression BPE)

* In practice most-used for tokenizers (2024–2025)
* This algorithm was first described in 1994 by Philip Gage, for compressing strings of characters by creating and using a translation table for frequently reoccurring combinations.
* goal: optimize byte-level storage size of text (compression)
* initially, Unicode normalization + chars (as opposed to byte level BPE introduced later)
* the algorithm compresses the text by grouping recurring character combinations iteratively into tokens, building a
  vocabulary
* the iterative grouping would continue until no tuple of tokens could be seen more than once in the text (break condition: “no frequent pair left”)
* then, instead of sending a long text character by character, you would send the vocabulary once and then send the
  token ids, that the other side could rebuild using the vocabulary

### Byte-Pair Encoding adjusted for Tokenization for LLMs

* LLMs have a similar objective of building a vocabulary
* new goal: optimizes model efficiency and statistical coverage
* While the algorithm is very similar, small adjustments have been made to accommodate the new goal and other LLM
  specifics
    * different goal -- therefore different break condition
    * (Break condition, join restrictions (there are no tokens that go like `_test_` -- tokens may
      only start with _, not end with _ ))
    * Byte-level BPE (introduced by GPT-2 (2019))
        * start of with all byte combinations.
        * Universal Coverage: even text that is not part of the data which is used to build the vocabulary can always be
          split into tokens
* while the goal is different, this still results in the compression aspect of the original BPE:
    * Frequency-Aware Compression: Common words get single tokens, while rare words get multiple tokens, but are still
      representable
* finally, extra control tokens may be added after training completed, which are used for signaling end of text, start or end of system/ user/ assistant messages or tool calls, among other use cases, depending on the model

### How do tokenizers split text up after training

The result of training step using the BPE algorithm is a list of merges of tokens, which result in a vocabulary. To tokenize a string, the tokenizer:

* Splits into base units (often bytes or characters)
* Applies merges greedily in **learned** order
* Stops when no more merges apply

unhappiness -> un h appiness
via merges:
i n 1
u n 2
es s 12
a p 22
ap p 23
app in 24
appin ess 25


### Alternative Approaches:

* WordPiece (2016) by Google
  * also a merge-based subword tokenizers, but merges the pair that maximizes likelihood, instead of the most frequent pair
  * tends to produce more linguistically meaningful merges.
  * WordPiece chooses merges that improve corpus likelihood, and that objective is conceptually aligned with how masked language models like BERT are trained.
  * used by BERT
* Unigram Language Model (2018)
  * different idea than bpe: start with a huge vocabulary and prune it down
  * unique property: probabilistic tokenization: The same word can be tokenized multiple ways, each with a probability
* BPE prevailed due to its simplicity in implementation and scalablility (easier to parallelize, faster for very large corpora) in practice, while differences in quality are small at scale compared to other methods.

### White Space Replacement Characters

* when you check out the actual vocabularies or work with tokens, you will stumble across weird characters that take
  place of whitespace characters such as spaces and newlines: `▁`, `Ġ` and `Ċ`
* this section explains why these occur

#### Replacement of Spaces

* this is for historical reasons
* Sennrich et al. proposed repurposing the BPE compression algorithm as a tokenization algorithm
* the bpe iteratively performs token merges (two tokens are merged together to form a new token)
* the algorithm stored these merges on disk, one merge per line with the two tokens that were merged separated by a space
* Spaces and newlines in tokens would obviously break this, so whitespace needed to be encoded

#### Why these characters specifically (see [ai.stackexchange](https://ai.stackexchange.com/questions/45054/why-do-llm-tokenizers-use-a-special-symbol-for-space-such-as-%C4%A0-in-bpe-or-in-sp))

* e tokens by replacing spaces with `▁` and `Ġ`
* TODO 

# References

* Sennrich, R., Haddow, B., & Birch, A. (2015) Neural Machine Translation of Rare Words with Subword Units. arXiv:
  1508.07909
    * apparently the paper that popularised subword tokenisers for NLP
    * proposed repurposing the BPE compression algorithm as a tokenisation algorithm
*

## Extra: While all tokens can be represented via Byte-Level BPE, this does not mean the model might not generate invalid Unicode
* Extra: decoding may fail (see emoji combinations) -- just cause everything can be encoded, does not mean everything
  can be decoded valid in the utf-8 standard


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
* marry poppins comes around and Supercalifragilisticexpialidocious'es this idea
* effect of typos



















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







