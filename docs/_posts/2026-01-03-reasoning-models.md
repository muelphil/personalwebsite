---
layout: post
title: "The Hype around the \"Hmmm\": Why Reasoning Models Are Less Magic Than They Seem"
date: 2026-01-03 00:00:00 +0200
title_image: 'Reasoning_Models/title_image'
tags: [ "LLMs" ]
read_time: 9
abstract: "Reasoning models promise AI that \"thinks\", but the reality is less magical. In this post I explore how inference-time scaling works, why internal monologues are often just learned mimicry, and the hidden costs of letting models (over)think."
short_abstract: "Reasoning models promise AI that \"thinks\", but the reality is less magical and very expensive at the same time."
---


If you’ve been using LLMs, you’ve probably noticed all the buzz around reasoning models. These are the models that
"think" before they speak, or at least give the impression of it. But how did we get here, and why the hype?

## Historical Background

Long before reasoning models became a product category, we already had Chain-of-Thought prompting: the simple but
powerful trick of asking models to “think step by step” ([Wei et al., 2023](#ref-wei2023)). It worked surprisingly well,
especially for math, logic puzzles, and multi-step problems. At the time, this felt less like a new capability and more
like learning how to talk to the model in a way that exposed what it already knew.

With the release of models like DeepSeek-R1 in January
2025 ([Deepseek-AI, 2025](#ref-deepseek2025)), reasoning stopped being a prompting hack
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

At a high level, “reasoning” in modern LLMs is best understood as a shift in where computation happens. In traditional
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
“But what if…”, “Let’s consider another case” or "Let's double check that" appear frequently. These patterns are not
accidental. During
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

Reasoning models are trained to produce a specific response structure: first, an internal reasoning trace often enclosed
by
special control tokens (e.g., `<think>…</think>`), followed by a final answer presented without uncertainty or
intermediate steps, based on the results of the reasoning process.

Control tokens have a practical purpose: they mark where reasoning begins and ends, making traces easy to parse during
training and easy to hide or summarize at inference time.

{% include posts/reasoning-models/gpt-oss-2+2-conversation.html %}

Importantly, most reasoning models are not architecturally different from standard instruction-tuned LLMs. They are
typically further fine-tuned variants built on the same transformer backbone and trained with the same next-token
prediction objective. What changes is not the architecture, but how the model is fine-tuned to use language during
inference.

Supervised fine-tuning (SFT) is the central mechanism by which reasoning models acquire their characteristic behavior.
During SFT, the model is exposed to examples that enforce a desired output structure (often using control tokens) along
with reasoning traces written in reflective language (i.e. [OpenThoughts3](https://huggingface.co/datasets/open-thoughts/OpenThoughts3-1.2M) dataset). These traces exhibit the patterns commonly associated with
“thinking,” such as decomposing problems, revisiting earlier steps, and expressing intermediate uncertainty. Through
this process, the model learns not only to produce correct answers, but to follow a specific linguistic trajectory while
doing so ([Wei et al., 2023](#ref-wei2023); [Nye et al., 2021](#ref-nye2021)).

In some training pipelines, SFT may be followed by an additional reinforcement learning phase based on verifiable
rewards (RLVR). Unlike reinforcement learning from human feedback (RLHF), which optimizes for human preference
judgments, RLVR ties rewards to objectively checkable outcomes such as correct final answers, passing test cases, or
valid proofs ([Cobbe et al., 2021](#ref-cobbe2021); [Lightman et al., 2023](#ref-lightman2023)). When applied, this step
reinforces reasoning behaviors that
reliably lead to correct outcomes, implicitly favoring strategies like exploring multiple solution paths or
double-checking results before committing to an answer.

The result is a model that uses language patterns that encourage it to think longer and more carefully. Nothing
fundamental has changed internally: reasoning is a learned behavior, acquired through fine-tuning and reinforcement,
that guides the model to explore, delay commitment, and verbalize uncertainty. Reasoning is not a new cognitive
mechanism.

Think of it like a preschooler capable of simple addition: 3+3=6, 7+1=8, but sometimes gets something wrong: 4+5=8.
Encouraging the preschooler to count on their fingers before answering will improve accuracy.
This doesn’t mean the kid suddenly understands arithmetic at a deeper level; they just take more careful steps to
reach the answer, which will significantly increase answer time.

## Pitfalls of Reasoning Models

Despite their strengths, reasoning models come with a set of trade-offs that are easy to overlook when focusing only on
benchmark gains.

The most obvious cost is token inflation. Reasoning models generate significantly more text per answer, which directly
increases latency and inference cost. This is often acceptable for hard problems, but wasteful for simple ones. Using
reasoning models to solve trivial tasks is slower, more expensive, and rarely beneficial.
This obviously depends on the model and is much approved on in some models, such as the *gpt-oss* family, which yielded
short reasoning traces for trivial answers in my benchmarking. The opposite extreme can be seen below.

{% include posts/reasoning-models/qwen-2+2-conversation.html %}

A more subtle issue is reward hacking. During fine-tuning, models learn that sounding reflective is often rewarded.
Phrases like “Let’s double-check” or “This seems tricky” become stylistic markers of good behavior, even when they add
no real value. In practice, this can lead to overcritical or overthinking behavior: questioning obvious facts,
revisiting already-correct steps, or spiraling into unnecessary doubt. In extreme cases, this results in self-induced
confusion, looping reasoning traces, or outright failure to converge on an answer.

Longer reasoning also amplifies exposure bias. During training, each reasoning step is conditioned on a clean,
human-written or curated prefix. During inference, the model conditions on its own generated thoughts. A small early
mistake can propagate through the entire chain of thought, becoming increasingly entrenched as the model elaborates on
it.

There currently are also practical limitations in state-of-the-art inference frameworks. Reasoning cannot be limited to
a given amount of tokens. If generation is cut off due to token limits or max-length constraints, you may end up with
half a thought and no final answer. This also effects structured decoding, which was previously introduced to gain model
outputs that could reliably be parsed, for example by enforcing coherence of the final model output to json schemes.
This reliability is compromised in reasoning models due to unpredictable length of reasoning traces, which can interrupt
or truncate outputs.

Of course, providers are aware of these issues and work on improving on them. For example, from what I have seen, the
*gpt-oss* model family was able to keep reasoning traces relatively short on trivial tasks. While I am a huge fan of
Mistral and
their Ministral models, their reasoning models are the opposite extreme: in my benchmarks they have been severally
inconsistent in respecting control tokens and concluding reasoning, often engaging in repeating reasoning loops,
sometimes
resulting in infinite generations. They have also failed to solve tasks that their instruction tuned counterparts
consistently were able to solve, due to being overcritical.

{% include posts/reasoning-models/ministral-conversation.html %}

This makes them unreliable in systems that depend on predictable structure, and
highlights that reasoning behavior is still a fragile, learned convention rather than a robust capability.

Finally, inference-time scaling shows diminishing returns: beyond a point, “thinking longer” mostly adds noise and
instability rather than accuracy. Reasoning models are powerful tools, but they are not free, and they are not
universally better. Like most things in machine learning, they work best when applied deliberately, with a clear
understanding of both what they add — and what they take away.

<style>
{% include posts/reasoning-models/conversation.css %}
</style>

## References

{% include scientific_reference.html
shortcut="deepseek2025"
authors="DeepSeek-AI"
year="2025"
title="DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning"
link="[arxiv:2501.12948](https://arxiv.org/abs/2501.12948)"
%}

{% include scientific_reference.html
shortcut="wei2023"
authors="Wei, J., Wang, X., Schuurmans, D., Bosma, M., Ichter, B., Xia, F., Chi, E., Le, Q., Zhou, D."
year="2023"
title="Chain-of-Thought Prompting Elicits Reasoning in Large Language Models"
link="[arXiv:2201.11903](https://arxiv.org/abs/2201.11903)"
%}

{% include scientific_reference.html
shortcut="cobbe2021"
authors="Cobbe, K., Kosaraju, V., Bavarian, M., Chen, M., Jun, H., Kaiser, L., Plappert, M., Tworek, J., Hilton, J.,
Nakano, R., Hesse, C., Schulman, J."
year="2021"
title="Training Verifiers to Solve Math Word Problems"
link="[arXiv:2110.14168](https://arxiv.org/abs/2110.14168)"
%}

{% include scientific_reference.html
shortcut="lightman2023"
authors="Lightman, H., Kosaraju, V., Burda, Y., Edwards, H., Baker, B., Lee, T., Leike, J., Schulman, J., Sutskever, I.,
Cobbe, K."
year="2023"
title="Let's Verify Step by Step"
link="[arXiv:2305.20050](https://arxiv.org/abs/2305.20050)"
%}

{% include scientific_reference.html
shortcut="nye2021"
authors="Nye, M., Andreassen, A. J., Gur-Ari, G., Michalewski, H., Austin, J., Bieber, D., Dohan, D., Lewkowycz, A.,
Bosma, M., Luan, D., Sutton, C., Odena, A."
year="2021"
title="Show Your Work: Scratchpads for Intermediate Computation with Language Models"
link="[arXiv:2112.00114](https://arxiv.org/abs/2112.00114)"
%}