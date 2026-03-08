---
layout: post
title: "Byte-Pair Encoding Explained: The Algorithm Powering Modern LLM Tokenization"
date: 2026-03-08 8:00:00 +0200
title_image: 'tokenization/title_image_bpe'
tags: [ "Computer Science", "Large Language Models" ]
read_time: 10
abstract: "How does a tokenizer actually learn which subwords to put in its vocabulary? This post covers Byte-Pair Encoding: the compression algorithm from 1994 that was repurposed for modern LLMs, how it was adapted for neural language model training, how byte-level and character-level variants differ, and why tokenizer vocabularies contain strange-looking characters like Ġ and ▁."
short_abstract: "From a 1994 compression algorithm to the tokenizer powering modern LLMs: how Byte-Pair Encoding works and why it became the standard."
---

In the [previous post]({% post_url 2026-02-27-tokenization-vocabulary-tradeoffs %}), we worked through the design space of tokenization vocabularies, going from character-level extremes to word-level pitfalls, arriving at subword tokenization as the principled middle ground. But we left open the question of how a tokenizer actually learns which subwords belong in its vocabulary. Good subwords are not handpicked. They emerge from a statistical process that runs over the training corpus before any language model training begins.

This post covers one of the most widely used algorithms behind that process: **Byte-Pair Encoding**, or BPE. Among the several approaches that exist (such as WordPiece and Unigram Language Models), BPE-based tokenizers are the most common in modern LLMs today. We will look at where the algorithm came from, how it was adapted for language model training, and what those strange-looking characters in tokenizer vocabularies actually mean.

To make the algorithm as concrete as possible, I have also built an interactive demo of the training process. By default, it shows a version that closely resembles the algorithm as it is implemented in modern GPT-style tokenizers, but you can switch to the original compression version in the settings.

{% include link_block.html
image="tokenization/bpe-visualizer"
title="Byte-Pair Encoding Visualizer - Interactive Algorithm Demo"
text="Step-by-step visualization of the Byte Pair Encoding (BPE) algorithm used for compressing data and building
vocabularies for LLMs."
url="https://philipmueller.dev/bpe-visualization/
"
%}

## The Original Byte-Pair Encoding

BPE was first described in 1994 by Philip Gage, not as a tokenization strategy, but as a method for **compressing bytes**. The goal was to optimize the byte-level storage size of text by replacing frequently recurring byte combinations with shorter representations, building a translation table in the process.

The algorithm works iteratively. Starting from individual bytes, it scans the input for the most frequently occurring pair of adjacent tokens and merges them into a single new token. This new token is added to the vocabulary, all occurrences of the pair in the text are replaced, and the process repeats. Each merge reduces the total number of tokens in the text by one unit — the two most common neighbors collapse into one.

{% include image.html url="tokenization/merging_animation.avif" description="Animation of the [Byte-Pair Encoding Visualizer](https://philipmueller.dev/bpe-visualization/) showing how a tokenizer builds its vocabulary based on frequencies in the training data. Because the training data contains many words ending in “ation,” the algorithm repeatedly merges tokens until “ation” emerges as a subword-token in the vocabulary."%}

The algorithm continues until no pair of tokens appears more than once in the text (the natural break condition of the compression use case), or until a target compression rate is reached. The result is a vocabulary encoded as a translation table of all the merges applied, alongside the original sequence compressed into a sequence of tokens IDs. To reconstruct the original text, the receiver needs the vocabulary once, then the token IDs.

It is a simple and elegant algorithm, and that simplicity turns out to be one of the main reasons it has held up so well.

## Adapting BPE for LLM Tokenization

BPE was originally designed to minimize storage size. When [Sennrich et al. (2016)](#ref-sennrich2016) proposed repurposing it for neural machine translation, the **goal shifted**: instead of compressing text as far as possible, the aim is to produce a fixed-size vocabulary that efficiently represents the language. The model needs enough tokens to understand and generate text fluently, but not so many that memory and computation become unmanageable.

The algorithm is largely the same, but a few key adjustments make it work well for this new purpose:

- **Stop condition.** Instead of merging until no pair occurs more than once, training stops once the vocabulary reaches a **target size**. This is the primary design knob: a larger vocabulary means fewer tokens per sequence, but more memory and output-layer computation.
- **Base units.** Depending on the tokenizer variant, training starts from **bytes or characters**. This choice has significant downstream consequences for vocabulary coverage and readability, as we will see in the variants below.
- **Whitespace and control symbols.** Spaces, newlines, and non-printable characters need special handling so that merge rules remain unambiguous. More on this below.
- **Special tokens.** Special control tokens representing end-of-text markers, user and system message delimiters and tool call boundaries are added **after training** is complete. They are not part of the learned merge list and therefore can never be produced by tokenizing ordinary user input — an important security and correctness property.

Despite these adjustments, the core BPE behavior carries over directly. Merges are applied greedily in the order they were learned. Common sequences tend to become single tokens, and rare sequences are split into smaller, more frequent subwords. The frequency-aware compression that made the original algorithm effective is exactly what makes it useful for language model tokenization: the vocabulary naturally mirrors the statistics of the training corpus.

### Byte-Level BPE (GPT-2)

The variant introduced by [Radford et al. (2019)](#ref-radford2019) for **GPT-2** takes byte-level BPE further by starting from all 256 possible byte values as the base alphabet. Before any merges are applied, the input text is converted to its UTF-8 byte representation.

This has one crucial advantage: **universal coverage**. Any string — emojis, rare scripts, novel words, deliberate typos — can always be tokenized, because every possible input ultimately decomposes into bytes, all of which are in the vocabulary. There is no out-of-vocabulary problem.

GPT-style byte-level BPE remains conceptually simple and scales cleanly to large corpora. It is the foundation of the tokenizers used in the GPT series and many models built on the same design.

### SentencePiece BPE (Meta, Mistral, Qwen)

SentencePiece is a language-independent tokenization framework developed at Google in 2018. It implements both BPE and Unigram Language Model under a single, unified training pipeline. SentencePiece BPE is used in models like Meta's LLaMA, Mistral, and Alibaba's Qwen, and starts from **Unicode characters** instead of bytes.

Because Unicode characters are human-readable, the resulting vocabulary is much easier to inspect and reason about. The trade-off is that vocabulary sizes tend to be somewhat larger than byte-level BPE for equivalent coverage, because individual Unicode code points are a less compact base alphabet than raw bytes.

SentencePiece BPE trades off **absolute universality** for readability and a slightly more natural alignment with how words appear in human languages. For multilingual models especially, starting from characters rather than bytes can produce more interpretable merges.

## Whitespace Replacement Characters

If you have ever inspected a tokenizer vocabulary directly or worked hands-on with LLM tokenization output, you have almost certainly encountered unusual-looking characters taking the place of spaces and newlines: `▁`, `Ġ`, and `Ċ` are the most common. These are not accidents or encoding errors. They exist for a principled reason rooted in how merge rules are stored.

When [Sennrich et al. (2016)](#ref-sennrich2016) first repurposed BPE for NLP, the learned merge rules were stored in a plain-text `merges.txt` file. Each line represented one merge:

```
left_token SPACE right_token NEWLINE
```

The format uses spaces to separate the two tokens being merged, and newlines to separate individual merge rules. This creates a hard constraint: **token strings themselves cannot contain spaces or newlines**. If they did, parsing the file would become ambiguous, as you could no longer tell where one token ended and the separator began.

The solution is to replace whitespace characters with visible, non-whitespace Unicode symbols before storing them. The two main tokenizer families handle this differently.

### Why `Ġ` Represents a Space in GPT-Style Tokenizers

This choice traces back to the byte-level BPE design introduced by [Radford et al. (2019)](#ref-radford2019) for GPT-2. Although byte-level BPE uses individual bytes as its base alphabet, the team wanted vocabulary files to remain **human-readable**. So rather than storing raw bytes, tokens are stored as Unicode characters.

The problem is that some bytes do not map cleanly to printable Unicode characters. The solution was a remapping scheme: common printable ASCII and Latin-1 characters are preserved as-is, while [the remaining non-printable byte values are mapped to unused Unicode code points starting at 256](https://github.com/openai/gpt-2/blob/master/src/encoder.py#L9). This also includes spaces and newline, that would break the format of the file storing the merges, as detailed above.

Concretely:
- **Space (byte 32)** is mapped to Unicode code point 288 → **Ġ**
- **Newline (byte 10)** is mapped to Unicode code point 266 → **Ċ**

The mapping is injective and reversible: by splitting any token string into its Unicode characters and reversing the mapping from Unicode characters back to byte values, you can recover the original byte sequence. The scheme guarantees a printable character, no collision with standard ASCII, and a clean round-trip back to bytes — exactly what the file-backed vocabulary format requires.

### Why `▁` Represents a Space in SentencePiece Tokenizers

SentencePiece uses a different approach. Rather than a byte-level remapping, it simply replaces all whitespace characters with the **lower one-eighth block** character `▁` (U+2581) before tokenization.

The motivation is stability: text preprocessing pipelines sometimes trim, collapse, or normalize whitespace in inconsistent ways. By replacing spaces with a visible, safe placeholder before any merges are applied, SentencePiece ensures that tokenization is stable and reproducible regardless of external whitespace quirks. The `▁` character was chosen because it is visually distinct and very rare in natural text, making collisions with genuine input essentially impossible.

## How Tokenizers Split Text After Training

The output of the BPE training step is an ordered list of merge rules, which together define the vocabulary. When a tokenizer encounters a new string at inference time, such as a user's prompt, it does not run the training loop again. Instead, it applies the learned merges in a fast forward pass:

1. **Split into base units.** For byte-level BPE, this means converting the input to its UTF-8 byte sequence and treating each byte as an individual token. For character-level variants, the input is split into Unicode characters.
2. **Apply merges greedily in learned order.** Starting from the first merge rule, the tokenizer scans the token sequence and replaces all occurrences of the learned pair with the merged token. Then it moves to the second merge rule, and so on.
3. **Stop when no more merges apply.** Once the tokenizer has exhausted the merge list or no remaining adjacent pairs match any rule, the current token sequence is the final tokenization.

The ordering of merge rules matters. A pair that was merged earlier in training due to higher frequency gets priority over pairs merged later. This is what gives BPE its greedy, frequency-aware character: common sequences collapse into single tokens early, while rare or novel sequences remain split into their more primitive constituents.

## Alternative Approaches

BPE is not the only subword tokenization algorithm, and it is worth briefly understanding the alternatives and why BPE has prevailed in practice.

**WordPiece** (2016, Google) is also a merge-based subword tokenizer, but the criterion for choosing which pair to merge is different. Rather than always picking the most frequent pair, WordPiece selects merges that **maximize the improvement to the corpus likelihood** — a probabilistic objective. This tends to produce more linguistically meaningful merges, and its objective is conceptually aligned with how masked language models like BERT are trained. WordPiece is used in BERT and its derivatives.

**Unigram Language Model** (2018) takes the opposite approach entirely. Rather than starting small and merging up, it starts with a large candidate vocabulary and **prunes it down** by iteratively removing tokens whose removal least degrades the corpus likelihood. The result is a probabilistic tokenizer with a unique property: the same word can legitimately be tokenized in multiple ways, each with a probability. This is useful for training with regularization, since the model sees the same word represented differently across training steps.

BPE has prevailed in practice largely due to its **simplicity and scalability**. It is straightforward to implement, easy to parallelize, and fast on very large corpora. The quality differences between BPE, WordPiece, and Unigram LM are small at scale, so the practical advantages of BPE — speed, predictability, and a long track record — have made it the default choice for most modern LLM tokenizers.

## Your Turn!

If you haven’t already, now is a good moment to try the interactive visualizer! Now that we have covered the algorithm in theory, step through the merge process and watch how the vocabulary gradually emerges from the training data. Keep an eye on which fragments get merged first. You will often see common subwords like `ing`, `tion`, or `pre` quickly turn into single tokens, while rarer sequences remain split into smaller pieces.

{% include link_block.html
image="tokenization/bpe-visualizer"
title="Byte-Pair Encoding Visualizer - Interactive Algorithm Demo"
text="Step-by-step visualization of the Byte Pair Encoding (BPE) algorithm used for compressing data and building
vocabularies for LLMs."
url="https://philipmueller.dev/bpe-visualization/
"
%}

## References

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
