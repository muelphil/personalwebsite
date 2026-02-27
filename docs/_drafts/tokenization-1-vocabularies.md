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
* this post tries to intuitively explain why different sizes for vocabularies are chosen and why -- from a logical reasoning standpoint -- the tokenization in words and subwords makes sense
* in the next post, we will go into the algorithm behind most modern tokenizers today.

## Understanding the sizes of vocabularies

* Lets first recap some important terms: (keep this is bullet points with text)
  * **Tokens**: units of the llms generation, can be differnet length. In modern models, these are characters, words and even subwords.
  * **subwords**: TODO, i.e. `general` and `izability` in generalizability 
  * **token_ids**: TODO
  * **vocabularies**: TODO
* Today, tokenizers are the only thing trained before the otherwise end to end training pipelines of LLMs
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