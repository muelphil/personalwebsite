---
layout: post
title: "Tokenization"
---

# Tokenization

* what are tokens: words, subwords, or even single characters
* intuition: if you know what a book is and you know what a store is, then you know what a bookstore is

* why not only single character tokens (inflation, no semantics)
* why not tokens for ever single word (not possible, training complicated as some words barley show up)
* Why do most tokens include spaces (cause that would inflate tokens while spaces have little semantic meaning on their
  own)
* Bpe (how vocab is built)
  * In practice most-used for tokenizers (2024–2025)
  * Link to original (https://en.wikipedia.org/wiki/Byte-pair_encoding)
  * first described in 1994 by Philip Gage, for encoding strings of text into smaller strings by creating and using a translation table.
  * Main goal: maximally compress text
  * Explain how it works
  * break condition: “no frequent pair left” 
  * used in: ...
  * Visualization https://www.bpe-visualizer.com/ Byte Pair Encoding Visualizer
* Adjustments for LLMs
  * different goal -- therefore different break condition
  * (Break condition, join restrictions (there are no tokens that go like `_test_` -- tokens may
    only start with _, not end with _ ))
  * Byte-level BPE 

Compression BPE: optimizes byte-level storage size
Tokenization BPE: optimizes model efficiency and statistical coverage


* How the tokenizer process texts into tokens
* https://www.louisbouchard.ai/prompting-llms/

* Ġ, ▁, Ċ

* marry poppins comes around and Supercalifragilisticexpialidocious'es this idea
* effect of typos
* Extra: decoding may fail (see emoji combinations) -- just cause everything can be encoded, does not mean everything can
be decoded valid in the utf-8 standard


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