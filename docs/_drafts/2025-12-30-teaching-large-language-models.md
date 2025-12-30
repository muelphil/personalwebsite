---
layout: post
title: "Educational Resources for Teaching Large Language Models"
---

- Transformer Explainer <https://poloclub.github.io/transformer-explainer/>
- https://ngrok.com/blog/prompt-caching/
  - found via https://simonwillison.net/2025/Dec/19/sam-rose-llms/
- https://bbycroft.net/llm (generally has nice visualizations, see https://samwho.dev/)
- 3B1B Series
- https://www.bpe-visualizer.com/ Byte Pair Encoding Visualizer

## Embeddings

**Figure:** _Word embedding vector projection illustrating the analogy “man is to king as woman is to queen.”_

The resulting vector from the operation **king − man + woman** (pink) lies closest to the embedding of **“queen”** (green), demonstrating how semantic relationships are captured as geometric directions in embedding space.


_Source:_ [**Word Embedding Demo - CMU School of Computer Science**](http://cs.cmu.edu/~dst/WordEmbeddingDemo/), Associated Paper: Bandyopadhyay, S., Xu, J., Pawar, N., & Touretzky, D. (2022) _Interactive Visualizations of Word Embeddings for K-12 Students_. DOI:[10.1609/aaai.v36i11.21548](https://doi.org/10.1609/aaai.v36i11.21548)

## Attention

**Figure:** Visualization of attention in a Transformer model. Displayed is **Layer 5 of 5** and **Attention Head 4**, highlighted in red, for an _Input–Input_ attention example illustrating how attention operates in a translation task using a full encoder–decoder Transformer. Tokens following “it\_” are greyed out to indicate masked attention, as typically applied in large language models (LLMs).

Visualization adapted from the [_Tensor2Tensor Intro_ Colab notebook ](https://colab.research.google.com/github/tensorflow/tensor2tensor/blob/master/tensor2tensor/notebooks/hello%5Ft2t.ipynb#scrollTo=OJKU36QAfqOC)featured in [_The Illustrated Transformer_](https://jalammar.github.io/illustrated-transformer/) by Jay Alammar.




**Figure:** _Visualization of the attention mechanism in GPT-2 (layer 1, head 8 of 12) using the_ **_Transformer Explainer_** _tool_ (Huang et al., [_Transformer Explainer: Interactive Learning of Text-Generative Models_](https://arxiv.org/abs/2408.04619)).

For the input sentence **“the blue fluffy creature likes red apples”**, the token **“apples”** attends strongly to **“red”**, illustrating how attention captures local contextual relationships between words.



This notebook was inspired by [GPT token encoder and decoder](https://observablehq.com/@simonw/gpt-tokenizer) and partially uses python portings of their code






The embeddings used here come from the **"glove-wiki-gigaword-50"** model, a compact and efficient dataset that:

* Uses **50-dimensional** vectors (lightweight and fast to load)
* Captures broad semantic relationships between words
* Is ideal for educational and interactive exploration

```python
import gensim.downloader
model = gensim.downloader.load("glove-wiki-gigaword-50") # replace with "word2vec-google-news-300" for Google News Word2Vec (Warning: much bigger size!)
print("Vocabulary size:", len(model.key_to_index))

vec = model["sushi"] - model["japan"] + model["germany"]

# Find most similar tokens to this vector
results = model.most_similar(positive=[vec], topn=10)
print("Top 10 most similar tokens:\n")
for word, score in results:
    print(f"  {word:15s}  similarity = {score:.3f}")
```