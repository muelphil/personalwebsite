---
layout: post
title: "Educational Resources for Teaching Large Language Models"
abstract: "A one-day workshop that uses 3D modeling and printing to teach problem-solving, abstraction, and core principles of computer science education"
tags: [ "Computer Science", "Large Language Models", "Teaching" ]
---

Im am a big fan of educational resources that visualize complex concepts making them tangible and allowing for building intuition. During the preparation of a 1 day workshop on how LLMs work architecturally, I scouted some resources. This post presents a list of tools and visualizations I find helpful for understanding and teaching large language models. I will update this list as I find new tools worthy of addition.

## Whole Architecture
### Transformer Explainer

{% include image.html url="LLM_Teaching_Material/transformer_explainer" description="Interactive visualization of the GPT-2 model architecture."%}

* [Transformer Explainer](https://poloclub.github.io/transformer-explainer/) (introduced by [Cho et al. (2024)](#ref-cho2024)) is one of the most valuable tools in the list
* contradictory to its name, it does not visualize the basic encoder-decoder transformer architecture, but the autoregressive decoder architecture of gpt2 specifically, which is fundamental to how language models work today
* allows interactive assessment of each of the different processing steps and works not with a mockup but actually runs the gpt-2 model in your browser (after downloading 600MB of model weights, OUFF)
* great for explaining different concepts at a high level, specifically valuable for showcasing attention and decoding
* very good for using it as a common thread throughout workshops/ lectures, explaining individual concepts with different visualizations, coming back to this visualization as an overview, that ties everything together.

### [LLM Visualization](https://bbycroft.net/llm) by [Brendan Bycroft](https://bbycroft.net/)

{% include image.html url="LLM_Teaching_Material/bbycroft.net_llm" description="A visualization and walkthrough of the LLM algorithm that backs OpenAI's ChatGPT."%}

* 3D rendered architecture for the models GPT-2 (small), nano-gpt, GPT-2 (XL) and GPT-3
* rendered models don't abstract parameter sizes or operation and show every single parameter for the smaller models, while keeping the scale for larger models. This allows you to "explore the algorithm down to every add & multiply, seeing the whole process in action" and makes it great for showing comparison between the different models regarding size.
* provides an animated walkthrough and writedown on the different parts
* however, size of these models can get overwhelming and the models look like space ships from far away

### [3B1B Series on Large Language Models](https://www.youtube.com/watch?v=wjZofJX0v4M&list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi&index=6) by [Grant Sanderson](https://www.3blue1brown.com/)

{% include image.html url="LLM_Teaching_Material/3b1b_llm_series" description="Part 1 of the 3 part LLM series of Grant Sanderson, available on his YouTube-Channel 3Blue1Brown"%}

* Grant Sanderson has become popular for producing intuitive visualizations for complex concepts in math and machine learning.
* Rightfully so and it is no different for his 3 part series on transformers.
* With a total runtime of 76mins, it provides a great walkthrough all the different steps on the basis of GPT-3, using intuitive explanations and great visualizations. It is great for building intuition and ties it all together by cumulativley summing up parameters of each individual step explained, ending up at the 175B parameters GPT3 uses.
* What I really value are short insights like the information and experiment he provides on the superposition concept in Part 3 of the series, that really helped me dig deeper and understand how embeddings work.

### [microgpt Playground](https://huggingface.co/spaces/webml-community/microgpt-playground) by [Joshua Lochner](https://www.linkedin.com/feed/update/urn:li:activity:7430293790965538816/)
* a Hugging Face Space only recently published by Joshua Lochner, who is working for transformer.js, a library that allows you to run huggingface transformers directly in your browser, with no need for a server!
* educational neural network builder, allowing you to build and train an llm, learning about their architectures from the ground up
* while I havent used it myself yet, I believe it could be great when complemented with some tutorials in form of guided experiments.

## Tokenization
### [Byte-Pair Encoding Visualizer](https://philipmueller.dev/bpe-visualization/) by me

* Building vocabularies for the tokenization is one of the few steps that is happening before the otherwise end-to-end training process of large language models.
* The most commonly used algorithm for building vocabularies is the byte-pair encoding algorithm, originally [described by Philip Gage in 1994](https://en.wikipedia.org/wiki/Byte-pair_encoding) for compressing data
* [Sennrich et al. (2016)](#ref-sennrich2016) proposed repurposing the BPE compression algorithm as a tokenization algorithm
* I build an interactive tool for this algorithm that helps visualize how the algorithm iteratively joins the most frequent token paris to build a vocabulary from the ground up.
* It features settings to both emulate the original algorithm, used for compression, as well as adjustments made for repurposing it to build LLM vocabularies.

### [GPT Online Tokenizer](https://platform.openai.com/tokenizer)
* OpenAI hosted online tool for trying out tokenization on user provided input
* great for letting students explore tokenization of different inputs, specifically for different capitalization's, different languages, emojis, typos and technical terms.

## Embeddings
### [Word Embedding Demo](http://cs.cmu.edu/~dst/WordEmbeddingDemo/) by the CMU School of Computer Science
* introduced with the associated paper by [Bandyopadhyay et al. (2022)](#ref-bandyopadhyay2022)
* uses "300-dimensional pre-trained word vectors without subwords, generated from a fasttext.cc dataset containing a mix of Wikipedia text and news stories"
* after downloading the model, it allows for interactive assessment of embedding vectors
* dimension reduction is applied and vectors are viewed in a 3 dimensional graph
* allows visualization of prominent semantic relationships, that are captured as geometric directions in embedding space, such as the resulting vector from the operation **king − man + woman** lying closest to the embedding of **“queen”**.
* taylored for educational usage in K12, provides a tutorial and experiments students can engage with.

### Gensim Downloader
* if you want to let students programmatically explore, the gensim package provides access to datasets for this matter in python.
* I found the "glove-wiki-gigaword-50"** model ideal for educational and interactive exploration, a compact and efficient dataset that uses **50-dimensional** vectors (lightweight and fast to load) and captures broad semantic relationships between words.

```python
import gensim.downloader
# replace with "word2vec-google-news-300" for Google News Word2Vec (Warning: much bigger size!)
model = gensim.downloader.load("glove-wiki-gigaword-50")
print("Vocabulary size:", len(model.key_to_index))

vec = model["sushi"] - model["japan"] + model["germany"]

# Find most similar tokens to this vector
results = model.most_similar(positive=[vec], topn=10)
print("Top 10 most similar tokens:\n")
for word, score in results:
    print(f"  {word:15s}  similarity = {score:.3f}")
# Output:
# gourmet          similarity = 0.692
# fries            similarity = 0.672
# sausages         similarity = 0.652
# hamburger        similarity = 0.638
```

### Superposition
* Superposition is one of the core concepts in explainability, trying to understand how large langauge models store knowledge and model language using embeddings
* The idea is that during training, if there are more features than dimensions, models are capable of 'cramping' vectors that are almost orthogonal to one another, allowing them to represent much more features than there are dimension, while facing minimal performance loss.
* This is briefly shown by [3B1B in How might LLMs store facts -- Superposition](https://www.youtube.com/watch?v=9-Jl0dxWQs8&t=1213s). While this is counterintuitive in lower dimensions, he presents an experiment where he is able to fit 10,000 vectors in a 100-dimensional space, that are all nearly orthagonal (between 89° and 91° to one another). The Johnson-Lindenstrauss Lemma he references shows that the amount of vectors you can 'cramp in', grows exponentially with dimension. 
* The [Toy Models of Superposition](https://transformer-circuits.pub/2022/toy_model/index.html) post by Anthropic researchers, also released as a paper ([Anthropic, 2022](#ref-elhage2022)) provides a visualized walkthrough of the concept.
* especially the visualizations may be very helpful in introducing this concept.
* A post by Axel Sorensen, [Toy Models of Superposition: Simplified by Hand](https://www.lesswrong.com/posts/8CJuugNkH5FSS9H2w/toy-models-of-superposition-simplified-by-hand) (2024) further breaks the concept down and showcases this on a simple example, making it very tangible.

### [Neuronpedia](https://www.neuronpedia.org/)
* found this after delving deeper into explainability in LLMs
* website linked to research, visualizing findings and providing interactive explorers
* What I found most intruiging is the [Attention SAE Research Paper](https://www.neuronpedia.org/gpt2sm-kk), where they attempt to decode features in embedding space on the last layer hidden states by training sparse autoencoders on them, allowing them to separate features.
* While the interactive tools are great for visualizations, these are very advanced concepts that go beyond a basic LLM workshop.


## Attention
### BertViz — Attention Mechanism Explorer
* open source tool for visualization of the attention mechanism of transformer models
* Nice writedown called [Explainable AI: Visualizing Attention in Transformers](https://comet.com/site/blog/explainable-ai-for-transformers/) by Abby Morgan on this tool.
* What it teaches: Multi-head attention patterns and how attention distributes across tokens and layers.
* Visualizes attention weights at model, head, and neuron levels. Useful for interpretability and understanding why the model attends to certain tokens.
- Primarily a python library tool, which requires using notebooks or with Comet integration to showcase it
- There are several colab notebooks available featuring this library, making is easy to access and show it on the fly to students, without having to run the cells yourself -- so no hardware required!, e.g. [BertViz Interactive Tutorial](https://colab.research.google.com/drive/1hXIQ77A4TYS4y3UthWF-Ci7V7vVUoxmQ?usp=sharing) and [Tensor2Tensor Intro](https://colab.research.google.com/github/tensorflow/tensor2tensor/blob/master/tensor2tensor/notebooks/hello_t2t.ipynb#scrollTo=odi2vIMHC3Rm).

## Decoding
### Logit lens
* introduced by [nostalgebraist](https://www.lesswrong.com/users/nostalgebraist) in [interpreting GPT: the logit lens](https://www.lesswrong.com/posts/AcKRB8wDpdaN6v6ru/interpreting-gpt-the-logit-lens), one of the early diagnostic experiments done in explainability of LLMs
* less about sampling, more about unembedding, logit lens is an approach where you apply the unembedding matrix not on the last layer hidden states, but on intermediate layers (after applying normalization)
* shows interesting behaviour of how the model converge on its prediction as layers progress
* there also is a nice post on this by Jay Alammar called [Finding the Words to Say: Hidden State Visualizations for Language Models](https://jalammar.github.io/hidden-states/), visualizing this behaviour.
* be wary: Early residuals were not trained to be decoded by the unembedding matrix. So Logit Lens is a diagnostic, not a faithful counterfactual. For causality, you need patching or ablation


### [LLM Sampling Methods](https://artefact2.github.io/llm-sampling/index.xhtml) by [Romain Dal Maso (“Artefact2”)](https://artefact2.com/)
* small online tool that shows the effect of different sampling methods, such as temperature, top-p and top-k, on the generation.
* great because it visualizes the probability distribution and distribution threshold imposed by different methods
* [LLM Sampling Methods](https://anuk909.github.io/llm-sampling/web/) is a forked version by [Shmulik Cohen](https://github.com/anuk909) that improves on clarity and focuses on sampling methods most relevant in LLM decoding, better for short demos


## Mixed
### [Prompt caching: 10x cheaper LLM tokens, but how?](https://ngrok.com/blog/prompt-caching/) by Sam Rose
* found via https://simonwillison.net/2025/Dec/19/sam-rose-llms/
* nice blog entry yon prompt caching that has some valuable short visualizations for embeddings, dimensionality and attention with the goal of explaining why and how prompt caching works.

### [Jay Alammars Blog](https://jalammar.github.io/)
* "visualizing machine learning, one concept at a time", this blog features many great visual posts on concepts in LLMs, featuring illustrations, animations and interactive demos.
* Reach from concepts generally relevant to LLM architecture, such as attention, to deep dive [posts on explainability](https://jalammar.github.io/explaining-transformers/)
* Provides crosslinks in the posts to notebooks that allow students to explore concepts such as [embeddings](https://github.com/jalammar/jalammar.github.io/blob/master/notebooks/nlp/01_Exploring_Word_Embeddings.ipynb) or that provide great interactive visualization e.g. for [attention](https://colab.research.google.com/github/tensorflow/tensor2tensor/blob/master/tensor2tensor/notebooks/hello_t2t.ipynb#scrollTo=OJKU36QAfqOC), that you can directly show in classroom

# Tools I am aware of but have not yet found the time looking into them
The following provides a short list of tools that are also attemtpting to visualize concepts in Large Language Models, but where I did not yet have the time evaluating them regarding their usuability in educational settings
* [VisBERT: Hidden-State Visualizations for Transformers](https://visbert.demo.datexis.com/) introduced by [van Aken et al. (2020)](#ref-vanAken2020)

# References
{% include scientific_reference.html
shortcut="cho2024"
authors="Aeree Cho, Grace C. Kim, Alexander Karpekov, Alec Helbling, Zijie J. Wang, Seongmin Lee, Benjamin Hoover, Duen Horng Chau"
year="2024"
title="Transformer Explainer: Interactive Learning of Text-Generative Models"
link="[arxiv:2408.04619](https://arxiv.org/abs/2408.04619)"
%}
{% include scientific_reference.html
shortcut="sennrich2016"
authors="Rico Sennrich, Barry Haddow, Alexandra Birch"
year="2016"
title="Neural Machine Translation of Rare Words with Subword Units"
link="[arxiv:1508.07909](https://arxiv.org/abs/1508.07909)"
%}
{% include scientific_reference.html
shortcut="bandyopadhyay2022"
authors="Saptarashmi Bandyopadhyay, Jason Xu, Neel Pawar, David Touretzky"
year="2022"
title="Interactive Visualizations of Word Embeddings for K-12 Students"
link="[doi:10.1609/aaai.v36i11.21548](https://doi.org/10.1609/aaai.v36i11.21548)"
%}
{% include scientific_reference.html
shortcut="elhage2022"
authors="Nelson Elhage, Tristan Hume, Catherine Olsson, Nicholas Schiefer, Tom Henighan, Shauna Kravec, Zac Hatfield-Dodds, Robert Lasenby, Dawn Drain, Carol Chen, Roger Grosse, Sam McCandlish, Jared Kaplan, Dario Amodei, Martin Wattenberg, Christopher Olah"
year="2022"
title="Toy Models of Superposition"
link="[arxiv:2209.10652](https://arxiv.org/abs/2209.10652)"
%}
{% include scientific_reference.html
shortcut="vanAken2020"
authors="Betty van Aken, Benjamin Winter, Alexander Löser, Felix A. Gers"
year="2022"
title="VisBERT: Hidden-State Visualizations for Transformers"
link="[arxiv:2011.04507](https://arxiv.org/abs/2011.04507)"
%}

