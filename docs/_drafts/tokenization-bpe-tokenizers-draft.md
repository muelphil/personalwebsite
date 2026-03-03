## Byte-Level BPE Explained: The Algorithm Powering GPT Tokenization

Alternative title: From Text to Tokens: Understanding Byte-Pair Encoding for LLMs

Following the previous post, that discussed advantages and restrictions of different vocabulary structures and sizes, we
will now look into one of the most popular algorithms modern tokenizers are based on.
among the several different approaches that exist (WordPiece, Unigram LM), algorithms that are based
on [Byte-Pair Encoding](https://en.wikipedia.org/wiki/Byte-pair_encoding) are most common in tokenizers these days
This post will cover how tokenizers based on BPE are trained on the training corpus and how they will eventually after
training tokenize unseen text.

To enhance learning, I have built an interactive demo of the training process. By default, it shows the version of the
algorithm adjusted to be more representative of how the algorithm is now implemented for LLM tokenizers as opposed to
the original one, but you can still apply original restrictions in the settings.

{% include link_block.html
image="tokenization/bpe-visualizer"
title="Byte Pair Encoding Visualizer - Interactive Algorithm Demo"
text="Step-by-step visualization of the Byte Pair Encoding (BPE) algorithm used for compressing data and building
vocabularies for LLMs."
url="https://philipmueller.dev/bpe-visualization/
"
%}

### The Original Byte-Pair Encoding (BPE, also Compression BPE)

* BPE and its variants are among the most widely used tokenization strategies in modern LLMs.
* This algorithm was first described in 1994 by Philip Gage, for compressing bytes by creating and using a translation
  table for frequently reoccurring combinations.
* goal: optimize byte-level storage size of text (compression)
* the algorithm compresses the text by grouping recurring byte combinations iteratively into tokens, building a
  vocabulary
* the iterative grouping would continue until no tuple of tokens could be seen more than once in the text (break
  condition: “no frequent pair left”) or a certain desired compression rate was reached
* then, instead of sending a long text byte by byte, you would send the vocabulary once and then send the
  token ids, that the other side could rebuild using the vocabulary

### Adaptation of Byte-Pair Encoding for Tokenization in LLMs

* BPE was originally designed for compressing text, but in LLMs, the **goal shifts**: we want a fixed-size vocabulary
  that efficiently represents the language, while still being able to handle any input text.
* The algorithm is largely the same, but some **key adjustments** make it work well for tokenization:
    * **Stop condition:** Instead of merging until no pair occurs more than once, training stops once the **vocabulary
      reaches a target size**. This ensures the model has a manageable number of tokens.
    * **Base units:** Tokenizers can start from either **bytes or characters**, rather than just characters, depending
      on the variant.
    * **Whitespace and control symbols:** Spaces, newlines, and other non-printable symbols need special handling so
      that merges remain unambiguous.
    * **Special tokens:** End-of-text, user/system markers, and other control tokens are added **after training**,
      separate from the learned merge list.
* Despite these changes, the **core BPE principles** remain:
    * Iteratively merge frequent adjacent units to build subwords.
    * Apply merges greedily during tokenization.
    * Frequency-aware representation: common sequences tend to become single tokens, rare sequences are split into
      smaller subwords.
* These adjustments allow BPE to efficiently tokenize massive corpora while still retaining the compression-inspired
  behavior that made the original algorithm so effective.

#### Byte-Level Byte-Pair Encoding (GPT-2)

* Introduced by Alec Radford et al. (2019) for **GPT-2**, byte-level BPE adapts the algorithm to work with **any UTF-8
  text**, ensuring universal coverage.
* **Base alphabet:** 256 possible byte values; all input text is converted to bytes before tokenization.
* **Advantages:**
    * Any text, including emojis, foreign scripts, or unseen characters, can always be tokenized.
    * Vocabulary size can remain relatively small because bytes are the atomic units.
* GPT-style byte-level BPE remains simple, efficient, and fully compatible with the LLM’s frequency-aware subword
  representation.

#### SentencePiece BPE (Meta, Mistral, Qwen)

* SentencePiece is a language-independent tokenization framework developed at Google in 2018
* Implements both **BPE** and **Unigram LM** under one unified training pipeline
* SentencePiece BPE is used in models like Meta **LLaMA**, Mistral, and Alibaba **Qwen**, and starts from **Unicode
  characters** instead of bytes.
* **Base alphabet:** Unicode characters, which keeps the vocabulary **human-readable** and easy to inspect.
* **Vocabulary size:** Generally larger than byte-level BPE for equivalent coverage because characters cover fewer
  sequences than bytes.
* SentencePiece BPE trades off **absolute universality** for readability and slightly more natural alignment with words
  in human languages.

### White Space Replacement Characters ([source](https://ai.stackexchange.com/questions/45054/why-do-llm-tokenizers-use-a-special-symbol-for-space-such-as-%C4%A0-in-bpe-or-in-sp))

* when you check out the actual vocabularies or work with LLMs hands on, you will stumble across weird characters that
  take
  place of whitespace characters such as spaces and newlines: `▁`, `Ġ` and `Ċ`
* Historical reason: [Sennrich et al. (2016)](#ref-sennrich2016) repurposed BPE for NLP.
* BPE learns merges of the form: `(t1, t2) → t1 + t2`
* These merges were stored in a `merges.txt` file:
    * `left\_token SPACE right\_token NEWLINE`
* Consequence:
    * Token strings themselves **cannot contain spaces or newlines**
    * Otherwise the merge file would become ambiguous and unparsable
    * Therefore, whitespace had to be **replaced with visible, non-whitespace symbols**

#### Why Ġ represents a space in GPT-style tokenizers

* This originates from the byte-level BPE design introduced by [Radford et al. (2019)](ref-radford2019) for GPT-2.
* wanted vocabulary files to be human readable
* so although byte-level BPE uses bytes as base alphabets, they stored content as characters
* some bytes correspond to spaces, newlines, control tokens and do not map cleanly to printable Unicode characters
* solution: preserving common printable ASCII and Latin-1 characters,
  the [remaining non-printable byte values are mapped to unused Unicode code points starting at 256](https://github.com/openai/gpt-2/blob/master/src/encoder.py#L9).
    * Space (Byte 32) gets transformed to unicode code point 288 → Ġ
    * Newline (Byte 10) gets transformed to unicode code point 266 → Ċ
* this guaranteed a printable character, no collision with standard ASCII, and a reversible mapping back to the original
  byte (by splitting into characters and using modulo on the unicode code point)

#### Why `▁` represents a space in Sentencepiece BPE tokenizers

* `▁` is another space substitution character you may run into when using sentencepiece tokenizers
* The replaced the spaces with this character, because text preprocessing sometimes trims or collapses spaces.
* Replacing with a visible, safe placeholder ensures tokenization is stable and reproducible, independent of external
  whitespace quirks.
* Chose a rare Unicode block character for that role

### How do tokenizers split text up after training

The result of training step using the BPE algorithm is a list of merges of tokens, which result in a vocabulary. To
tokenize a new string at inference time, the tokenizer:

* Splits into base units (in case of byte-level BPE into bytes)
* Applies merges greedily in **learned** order
* Stops when no more merges apply

### Alternative Approaches:

* WordPiece (2016) by Google
    * also a merge-based subword tokenizers, but selects merges to maximize likelihood improvement (probabilistic),
      instead of the most frequent pair
    * tends to produce more linguistically meaningful merges.
    * WordPiece chooses merges that improve corpus likelihood, and that objective is conceptually aligned with how
      masked language models like BERT are trained.
    * used by BERT
* Unigram Language Model (2018)
    * different idea than bpe: start with a huge vocabulary and prune it down
    * unique property: probabilistic tokenization: The same word can be tokenized multiple ways, each with a probability
* BPE prevailed due to its simplicity in implementation and scalablility (easier to parallelize, faster for very large
  corpora) in practice, while differences in quality are small at scale compared to other methods.

# References

{% include scientific_reference.html
shortcut="sennrich2016"
authors="Sennrich, R., Haddow, B., Birch, A."
year="2016"
title="Neural Machine Translation of Rare Words with Subword Units"
link="[arXiv:1508.07909](https://arxiv.org/abs/1508.07909)"
%}

{% include scientific_reference.html
shortcut="radford2019"
authors="Radford, A., Wu, J., Child, R., Luan, D., Amodei, D., Sutskever, I."
year="2019"
title="Language Models are Unsupervised Multitask Learners"
link="[PDF](https://cdn.openai.com/better-language-models/language_models_are_unsupervised_multitask_learners.pdf)"
%}


---

### Adaptation of Byte-Pair Encoding for Tokenization in GPT-2

* LLMs have a similar objective of building a vocabulary
* new (but related) goal: optimizes model efficiency and statistical coverage
* While the algorithm is very similar, small adjustments have been made to accommodate the new goal and other LLM
  specifics (introduced by [Radford et al. (2019)](ref-radford2019 for GPT-2)
    * Different break condition of the algorithm: max vocabulary size
    * Join restrictions, that prevent multiple different semantic units being joined into a single token (such as words
      and punctuation, or two words that often occur after one another)
    * Byte-level BPE
        * Instead of using Unicode characters for the base vocabulary, GPT-2 uses the 256 possible byte values as its
          base alphabet and converts input text to UTF-8 bytes
        * Universal Coverage: even text that is not part of the data which is used to build the vocabulary can always be
          split into tokens, without exploding Unicode vocabulary
* while the goal is different, this still results in the compression aspect of the original BPE:
    * Frequency-Aware Compression: Common words get single tokens, while rare words are split into frequent subwords
* finally, extra control tokens may be added to the vocabulary after training completed, which are used for signaling
  end of text, start or end of system/ user/ assistant messages or tool calls, among other use cases, depending on the
  model
    * these special tokens are not part of the merge list and as such cannot be the result of user input text
      tokenization

# TODOs (important)

* adjust bpe visualization prefix
