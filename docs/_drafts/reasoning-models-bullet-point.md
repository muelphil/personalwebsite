---
layout: post
title: "Reasoning Model Post Bullet Points"
---

# Reasoning Model Post Bullet Points
# “reasoning” aka inference-scaling aka Reinforcement Learning from Verifiable Rewards (RLVR)

## Historical Background

* Chain of Thought
* boom in reasoning models in January of 2025 (Deepseek)
* quickly adopted, due to significant performance increase, especially on math proofs, program synthesis, adversarial
  reasoning,
  uncertainty-heavy domains
* Reasoning Traces mostly hidden - when using ChatGPT you will notice headings, but cannot directly access it
    * Hidden for these reasons: (Keep this short and tight, its not as relevant)
        * safety (prevent users from seeing unsafe intermediate hypotheses, unfiltered associations or exploratory
          thoughts that are later rejected)
        * Intellectual Property (obfuscate prompting strategies, training artifacts, characteristic reasoning patterns)
        * alignment (reasoning traces may contradict the final answer, express uncertainty or disagreement, explore
          morally or politically sensitive alternatives, making reasoning paths hard to evaluate for users)
        * cost control (avoid increased network latency due to sending large reasoning traces)
* a lot of hype around reasoning models, but hard to understand what it really is/ how it works on a language level
* the goal of this post is to explain reasoning and why it may not be as cool as you might think

## What is reasoning?

* Inference-time scaling vs training-time scaling: reasoning models shift compute to inference
* Reasoning models do not necessarily learn better internal representations
* They often just: externalize uncertainty, delay commitment, brute-force via multiple thought paths
    * Looking into reasoning traces, you will mostly see certain reflective language patterns (Hmmm, Maybe, But what
      if, ...) learnt during training
    * learn to use epistemic markers and reflective language patterns in order to elicit loud thinking, as they may have
      seen in the base data during training in context of these patterns
    * as a result, they don't have better understanding, but they guide themselves to search the output space
* what reasoning is not: no tool usage, no explicit symbolic execution

## How Reasoning Models are trained

* Mostly fine-tuned instruction tuned models (no architectural changes), combined with system prompts
* Reasoning models are trained in two complementary stages. First, supervised fine-tuning (SFT) teaches the model how to
  reason by providing examples of structured, step-by-step solutions and reflective language, helping it learn not just
  answers but the process of thinking through problems. Next, reinforcement learning from verifiable rewards (RLVR)
  fine-tunes the model by rewarding outputs that include reasoning traces leading to correct answers, reinforcing both
  accuracy and the use of structured reasoning patterns. Together, these stages allow models to produce answers that are
  not only correct but explained clearly and logically.
* Models are trained to start and conclude reasoning using special control tokens, which help parse the output and hide
  reasoning traces to end users
    * <think> (deepseek), harmony (openai), [THINK] (mistral)
* Training shapes Reasoning -- some models try to question different approaches, try several times to check if they
  arrive at the same answer

TODO: To illustrate how models reason, include a generation for several different reasoning models for the same prompt,
asking a very simple question: "What is 2+2?"

## Issues with reasoning models

* Although they can solve tasks that instruction-tuned models previously struggled with and show increased accuracy,
  this comes at the price of token inflation.
* Reward hacking: during supervised fine-tuning models learn to sound reflective (“Let’s double-check…”) rather than
  actually being correct.
    * Being overcritical: They question things that are common sense, which not only increases token usage but may even
      lead to disregarding obvious facts (see Mistral).
    * Being overthinkers: They may question things they previously deemed correct. In the worst cases, this can cause
      thinking loops and ultimately infinite generations.
* Exposure bias (During training, each reasoning token is generated conditioned on a ground-truth prefix (teacher
  forcing). The model always “sees” a correct or at least plausible reasoning history. During inference, however, the
  model conditions on its own generated reasoning. Once it makes a small mistake early in the chain of thought, that
  mistake becomes part of the context and influences all subsequent tokens. As a result, the model performs well only
  under the exposure conditions it was trained on—and is biased when exposed to anything else. So instead of correcting
  itself, the model may confidently elaborate on a flawed premise, reinforcing the error step by step. This is why
  longer reasoning can sometimes reduce robustness rather than improve it.)
* as generation length increases, this comes with higher risk of:
    * the previously mentioned behaviours
    * Hallucinations
    * False confidence amplification: Longer reasoning → higher perceived correctness, even when the final answer is
      wrong.
* Reasoning cannot be terminated by users to produce an answer based on the current state: If generation is cut off by
  model length or the max\_tokens parameter, the result may contain an unfinished reasoning path.
* Inference-time scaling has diminishing returns and stability issues.
* Reasoning complicates structured decoding.
* Especially Mistral models are very unreliable in their responses and may fail to include reasoning tags.

## Conclusion:

* Reasoning models are a compute trade-off, a UX choice, a search heuristic
* They are not a fundamental leap in cognition, interpretability or grounded reasoning
* While they may be able to solve tasks better, they are not always the right choice, and can introduce costs and issue
  for tasks that instruction tuned models can solve just as well