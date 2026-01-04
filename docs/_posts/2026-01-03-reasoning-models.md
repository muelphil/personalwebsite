---
layout: post
title: "Deconstructing the Hype: Why Reasoning Models Are Less Magic Than They Seem"
date: 2026-01-03 00:00:00 +0200
title-image: 'Reasoning_Models/title_image'
tags: [ "LLMs" ]
read_time: 7
abstract: "Reasoning models promise AI that \"thinks\", but the reality is less magical. In this post I explore how inference-time scaling works, why internal monologues are often just learned mimicry, and the hidden costs of letting models overthink."
short-abstract: "Reasoning models promise AI that \"thinks\", but the reality is less magical. In this post I explore how inference-time scaling works, why internal monologues are often just learned mimicry, and the hidden costs of letting models overthink."
---


If you’ve been using LLMs, you’ve probably noticed all the buzz around “reasoning models.” These are the models that "
think" before they speak, or at least give the impression of it. But how did we get here, and why the hype?

## Historical Background

Long before “reasoning models” became a product category, we already had Chain-of-Thought prompting: the simple but
powerful trick of asking models to “think step by step” ([2201.11903](#2201.11903)). It worked surprisingly well,
especially for math, logic puzzles, and multi-step problems. At the time, this felt less like a new capability and more
like learning how to talk to the model in a way that exposed what it already knew.

With the release of models like DeepSeek-R1 in January
2025 ([https://arxiv.org/abs/2501.12948](https://arxiv.org/abs/2501.12948)), reasoning stopped being a prompting hack
and became a first-class feature. Suddenly, benchmarks jumped, particularly in math proofs, program synthesis,
adversarial reasoning, and uncertainty-heavy domains. The narrative was clear: if you let the model think longer,
performance improves. This idea spread fast, both in research and in marketing, because the gains were real and
measurable.

If you’ve used ChatGPT or similar systems, you’ll have noticed that activating “Thinking” doesn’t produce an immediate
answer. Instead, the model appears to reason first, often summarized in short intermediate notes. The full reasoning
trace, however, remains hidden. This is intentional: intermediate thoughts can be messy, unsafe, or misaligned, and
revealing them can expose proprietary prompting strategies. Keeping traces private also keeps responses concise and
avoids unnecessary latency. As a result, reasoning is heavily advertised and studied, but largely opaque to users in
practice.

This opacity feeds the hype. “Reasoning models” sound like a qualitative leap, as if models suddenly acquired a new
cognitive faculty. But beyond benchmarks and marketing, it’s often unclear what reasoning actually means at the language
level, or how different these models really are from instruction-tuned ones. The tension between real performance gains
versus fuzzy conceptual understanding is what motivated this post. The goal isn’t to dismiss reasoning models, but to
demystify them and explain why they might be less magical (and less universally useful) than you think.

## What is reasoning?

At a high level, “reasoning” in modern LLMs is best understood as a shift in where computation happens. In Traditional
models, providers tried to boost performance by scaling training compute, data or parameters. Once deployed, inference
is relatively cheap and fast. Reasoning models, in contrast, deliberately spend more compute at inference time. They
generate longer intermediate sequences, explore alternatives, and delay committing to an answer. This is often called
inference-time scaling: better answers by thinking longer, not by having learned fundamentally more during training.

Crucially, this does not automatically imply that reasoning models have learned better or more structured internal
representations of the world. Reasoning-focused training pipelines don't fundamentally alter internal representations of
the base model, and what changes most visibly is the structure and language patterns it uses during inference before
providing a final answer. Reasoning is primarily expressed as an output-level strategy, not a guarantee of deeper
internal understanding. The model is still a next-token predictor, just one that has been trained and instructed to
produce intermediate text before producing a final answer.

If you check out reasoning traces, what you mostly see is not formal logic but reflective language. Phrases like “Hmm”,
“Maybe”, “But what if…”, or “Let’s consider another case” appear frequently. These patterns are not accidental. During
training, models see these patterns in contexts of deliberation and problem solving, using exactly this kind of
epistemic and self-reflective language. In effect, it learns to guide itself through the output space by externalizing
uncertainty, postponing decisions, and trying multiple thought paths in sequence.

This is why reasoning often looks like search rather than insight. The model is not executing symbolic logic or
manipulating explicit representations; it is sampling and revising continuations in text space. Externalizing
uncertainty helps avoid early mistakes, and delaying commitment allows the model to consider alternatives before
settling on an answer. These are useful heuristics, but they are learned behavioral patterns, **not** new cognitive
machinery.

It’s also important to be clear about what reasoning is not. Reasoning models do not inherently use tools, perform
symbolic evaluations, or run explicit algorithms unless those capabilities are separately integrated. The “thinking”
happens entirely within the language model’s token generation process. What changes is how much text is generated before
an answer, and how that text is structured, not the fundamental nature of the model itself.

## How Reasoning Models are trained

Reasoning models are trained to produce a specific response structure: first, an internal reasoning trace enclosed by
special control tokens (e.g., `<think>…</think>`), followed by a final answer presented without uncertainty or
intermediate steps, based on the results of the reasoning process.

Control tokens have a practical purpose: they mark where reasoning begins and ends, making traces easy to parse during
training and easy to hide or summarize at inference time.

{% include posts/reasoning-models/gpt-oss-2+2-conversation.html %}

Importantly, most reasoning models are not architecturally different from standard instruction-tuned LLMs. They use the
same transformer backbone and the same next-token prediction objective. What changes is how they are fine-tuned to use
language during inference.

Training usually happens in two stages. First, supervised fine-tuning (SFT) exposes the model to the desired structure
enforced by the control tokens, along with reasoning traces that use reflective language. The training data may come
from examples of step-by-step solutions included in some datasets (e.g., TODO). These solutions exhibit the reflective
patterns we associate with “thinking”: decomposing problems, revisiting earlier steps, and expressing uncertainty. The
model learns not just to give correct answers, but to follow a particular linguistic trajectory along the way.

Second, reinforcement learning from verifiable rewards (RLVR) reinforces reasoning behaviors that lead to correct
outcomes. While SFT trains on explicit examples and reinforcement learning from human feedback (RLHF) trains on human
preferences, RLVR ties rewards to objectively verifiable success. This might include correct final answers, passing
tests, or valid proofs. In this step, only reasoning traces that improve accuracy are rewarded, encouraging behaviors
like exploring multiple approaches or double-checking results before answering.

The result is a model that uses language patterns that encourage it to think longer and more carefully. Nothing
fundamental has changed internally: reasoning is a learned behavior, acquired through fine-tuning and reinforcement,
that guides the model to explore, delay commitment, and verbalize uncertainty. Reasoning is not a new cognitive
mechanism.

Think of it like a preschooler capable of simple addition: 3+3=6, 7+1=8, but sometimes gets something wrong: 4+5=8.
Encouraging the preschooler to count on their fingers before answering will improve accuracy.
This doesn’t mean the child suddenly understands arithmetic at a deeper level; they just take more careful steps to
reach the answer, which will significantly increase answer time.

## Pitfalls of Reasoning Models

Despite their strengths, reasoning models come with a set of trade-offs that are easy to overlook when focusing only on
benchmark gains.

The most obvious cost is token inflation. Reasoning models generate significantly more text per answer, which directly
increases latency and inference cost. This is often acceptable for hard problems, but wasteful for simple ones. Using
reasoning models to solve trivial tasks is slower, more expensive, and rarely beneficial.
This obviously depends on the model and is much approved on in some models, such as the `gpt-oss` family. An extreme
case can be seen below.

{% include posts/reasoning-models/qwen-2+2-conversation.html %}

A more subtle issue is reward hacking. During fine-tuning, models learn that sounding reflective is often rewarded.
Phrases like “Let’s double-check” or “This seems tricky” become stylistic markers of good behavior, even when they add
no real value. In practice, this can lead to overcritical or overthinking behavior: questioning obvious facts,
revisiting already-correct steps, or spiraling into unnecessary doubt. In extreme cases, this results in self-induced
confusion, looping reasoning traces, or outright failure to converge on an answer.

Longer reasoning also amplifies exposure bias. During training, each reasoning step is conditioned on a clean,
human-written or curated prefix. During inference, the model conditions on its own generated thoughts. A small early
mistake can propagate through the entire chain of thought, becoming increasingly entrenched as the model elaborates on
it. Ironically, the very mechanism intended to improve reliability can reduce robustness: instead of correcting itself,
the model confidently builds a detailed justification around a flawed premise.

[//]: # (As reasoning traces grow longer, these risks increase. Additionally, Hallucinations become more likely.)

There currently are also practical limitations in state-of-the-art inference frameworks. Reasoning cannot be limited to
a given amount of tokens. If generation is cut off due to token limits or max-length constraints, you may end up with
half a thought and no final answer. This also effects structured decoding, which was previously introduced to gain model
outputs that could reliably be parsed, for example by enforcing coherence of the final model output to json schemes.

Of course, providers are aware of these issues and work on improving on them. For example, from what I have seen, the
`gpt-oss` model family kept reasoning traces relatively short on trivial tasks. While I am a huge fan of Mistral and
their Ministral models, their reasoning models are the opposite extreme: in my benchmarks they have been severally
inconsistent in respecting control tokens and concluding reasoning, often engaging in repeating reasoning loops, often
resulting in infinite generations. This makes them unreliable in systems that depend on predictable structure, and
highlights that reasoning behavior is still a fragile, learned convention rather than a robust capability.

Finally, inference-time scaling shows diminishing returns: beyond a point, “thinking longer” mostly adds noise and
instability rather than accuracy. Reasoning models are powerful tools, but they are not free, and they are not
universally better. Like most things in machine learning, they work best when applied deliberately, with a clear
understanding of both what they add — and what they quietly take away.

<style>
{% include posts/reasoning-models/conversation.css %}
</style>