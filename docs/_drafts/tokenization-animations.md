---
layout: post
title: "Tokenization Animations"
---

# Animations

Please implement the following animations and illustrations in /docs/_includes/posts/tokenization as includes, then include them here using the standard jekyll syntax. Please make them parameterized, parameterizing the speed, tokens, text, etc, if possible directly as part of this documents metadata and provide the data necessary for the animation via includes statement (inject it). If not possible, define variables directly in the animation includes files.

The animations should work using pure html/css/js. You may use canvas, but if possible, plain html/svg elements that are moved would be preferred. It should have transparent background and the items rendered on top of it. It should use the View Transition API (`document.startViewTransition`) and Web Animations API (WAAPI) (`element.animate`) where possible and provide clean, structured, guided animations.

The animation should not start itself. Before playing, there should be an overlay over the animation with an unintrusive semi transparent play button, indicating the user they can interact with it. When the user clicks the play button, the animations starts playing. When the animation is finished, there should be a 'reload' icon in the top right corner. Clicking anywhere on the animation should start playing it from the beginning.
Create svgs for the reload and play icon.

Visualization of tokens: please use the css provided in /docs/_includes/posts/tokenization/tokenization.css and extend upon it. The css should be directly included in tokenization.md. For each token, make up ids, but make sure that they are consistent: same token = same token id. For characters, use their character code (ASCII), for anything else, use made up token ids, 512 or higher.

## Animation of Autoregressive LLM
* animation of a language model inferring tokens, one by one
    * parameters: start tokens, i.e. ['Paris', ' is', ' the'], animated inferred tokens, i.e. [' city', ' of', ' light', '.']
    * visualization: start tokens on the left, a block with "LLM" in the middle, start token copies go "into" the LLM block (LLM has highest z-index), LLM block briefly shrinks, outputting/infer the next new token on the right (flying from behind the llm block to the right), when the LLM block hits the smallest scale, before regaining normal size. The next new token on the right is then moved to the other tokens on the left, left of the LLM block, for the next token to be inferred
    * this loops until all the inferred tokens are generated this way.

<figure>
{% include posts/tokenization/autoregressive-llm.html
   start_tokens="Paris; is; the"
   inferred_tokens=" city; of; light;.;<|endoftext|>"
   speed="1" %}
<figcaption>Autoregressive inference: the LLM consumes all preceding tokens and generates one new token at a time. Each generated token is appended to the context before the next inference step.</figcaption>
</figure>

## Animation of text being split up into character tokens
* animation of a text sequence being split into tokens, with 1 token per character.
* this is supposed to show an unrealistic edge case where tokenizers are simply splitting at every character.
* use token style but disable it based on container class ".disable", when removing disable the text should visually be split into tokens using transition of margin, padding, background color, etc.

<figure>
{% include posts/tokenization/character-tokenization.html
   text="The quick brown fox jumps over the lazy dog"
   speed="1" %}
<figcaption>Character-level tokenization: each character becomes its own token. While maximally flexible, this results in very long sequences — here, 44 characters produce 44 tokens.</figcaption>
</figure>

## Illustration of all possible tokens resulting from character combinations
* this is supposed to show another edge case where all character combinations are considered individual tokens
* no animation, just illustration: display 4 rows of tokens that are cut off by the width of the container (no overflow)
* each row has the tokens resulting from character combinations of the respective length
    * first row: a, b, c, d, e, f, ...
    * second row: aa, ab, ac, ad, ae, ...
    * third row: aaa, aab, aac, aad, ...
    * fourth row: aaaa, aaab, aaac, aaad, aaae, ...
* You do not need to use tokenids for that, you can skip them for this illustration

<figure>
{% include posts/tokenization/character-combinations.html
   alphabet="abcdefghijklmnopqrstuvwxyz"
   rows="4" %}
<figcaption>All possible tokens from character combinations of lengths 1–4. Even with just 26 letters, the vocabulary grows exponentially: 26 + 676 + 17,576 + 456,976 = 475,254 entries — before accounting for uppercase, digits, or punctuation.</figcaption>
</figure>

## Illustration of words with and without spaces being present in vocabularies
* no animation, just illustration: display a tokenized sentence, showing 2 tokens that differ only in there being a space in the beginning and different token ids
* highlight these 2 tokens
* parameterization: tokens, e.g. ['A', ' man', ' walked', ' past', ' a', ' snow', 'man'.], tokens to highlight, e.g. ['man', ' man']

<figure>
{% include posts/tokenization/vocabulary-spaces.html
   tokens="A| man| walked| past| a| snow|man"
   highlight="man| man" %}
<figcaption>Leading spaces are part of the token. <span class="token small"> man</span> and <span class="token small">man</span> are two distinct vocabulary entries with different token IDs — the tokenizer encodes the boundary between words directly into the token itself.</figcaption>
</figure>


Thats good, but we need to make some adjustments:
* posts/tokenization/autoregressive-llm.html
    * this is not working as expected. Please rework the animation. It should be similar to the current implementation, with the change of layout: instead of having 3 sections (input tokens, LLM block, output tokens), make it one container that may take up several lines. Blend in the currently not yet inferred tokens from the beginning, but set their opacity to 0. Put the LLM block at the end of the current token state, and play the animation as before. Key change is that the layout is flat and the tokens, the LLM block and the to be inferred tokens should all be at the same level. This should make it look like the LLM block is always moving to the end of the sequence, absorbing the context to generate the new token, then moving the new token to the context.
* posts/tokenization/character-tokenization.html
    * I have changed my mind. Demote this from an animation to an illustration, showing the final token state.

