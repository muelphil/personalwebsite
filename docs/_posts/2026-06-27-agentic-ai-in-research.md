---
layout: post
title: "Agentic AI in Research: Recent Developments, Emerging Trends and Their Impact on Scientific Research"
date: 2026-06-27 10:00:00 +0200
title_image: 'agentic_ai_intro_talk/title_image'
tags: [ "Agentic AI", "Large Language Models", "Research", "AI Systems" ]
read_time: 18
abstract: "From persistent agents to multi-agent systems operating at superhuman scale: a survey of recent developments in agentic AI, the verification bottleneck, and what this means for the future of scientific research."
short_abstract: "A written account of my HAICON 2026 talk on agentic AI: the shift from asking questions to delegating responsibilities, and the open challenges ahead."
---

A few weeks ago, I had the opportunity to give an introductory talk at the HAICON 2026 workshop *"Building Agentic ML Tools for Science: What Works and What Doesn't"* in Munich. The talk was designed as a dense overview of concepts, recent news, and trends in agentic AI, with a particular focus on how these systems are beginning to intersect with scientific research.

This post is a written version of that presentation. It covers the key developments I discussed, along with the references and sources mentioned in the slides. The views expressed here are my own and reflect personal observations and opinions formed during the preparation of the talk -- not official positions.

## What Is an Agent, Really?

The term "agent" is thrown around a lot, and it means different things depending on who you ask. For the purposes of this discussion, I use a working definition: an agent is a system that autonomously plans, acts, and iterates using tools to achieve a goal. An agent is **not** an LLM making a single tool call. The canonical loop is Goal → Plan → Act → Observe → Repeat, and three core properties distinguish agents from simple LLM interactions:

- **Goal-directed behavior**: the system works toward an explicit objective, not just toward producing a plausible response.
- **Decision-making**: it chooses subsequent actions based on intermediate results, not just the original prompt.
- **Iteration**: it refines outputs over multiple steps, observing and correcting as it goes.

In research, generative AI use cases span a wide range. Witte, Bayer, and Weber (2026) surveyed 118 potential use cases of generative AI for researchers across six categories: idea generation, literature review, methodology design support, data collection, programming, and data analysis and writing support[^1]. Agents extend these use cases from one-off assistance to continuous, iterative workflows.

## The Shift to Persistent Agents

Early LLMs were largely stateless: you send a prompt, get a response, and the context is lost. The new wave of agentic systems increasingly retains project-relevant knowledge, goals, tasks, and preferences across sessions and restarts. These **persistent agents** resume previous work automatically, maintain evolving context about users and projects, and can monitor systems and perform long-running workflows.

I see this as a fundamental shift in the interaction model: from *asking questions* to *delegating responsibilities*, and from the *prompt* as the unit of interaction to the *project*. The dominant paradigm is moving from short-lived assistants to persistent systems that operate continuously, remember previous interactions, and execute tasks over extended periods.

## Agent Harnesses — The New Operating Layer

Something that became increasingly clear during my preparation for the talk is that performance in agentic systems depends less on model capability alone and more on orchestration. **Harnesses** -- the software infrastructure layer wrapped around an AI model -- are becoming the new operating layer. They handle planning and task decomposition, context management and memory retrieval, tool routing and execution, verification and retry loops, and multi-step control flow across agents.

We are shifting from model-centric AI to system-centric AI. The real intelligence of agentic systems is increasingly located in the orchestration layer that coordinates models, tools, memory, and execution. Examples include coding harnesses like Claude Code, GitHub Copilot CLI, and OpenCode, as well as systems like Paperclip, which models software organizations as teams of specialized agents coordinated through structured workflows.

## Data, Memory, and Context

As top-tier frontier models become increasingly comparable on standard benchmarks[^2], the bottleneck in agentic systems is shifting from model capability toward how effectively systems persist, structure, and retrieve contextual knowledge over time. Long-horizon agents require persistent external state that goes beyond context windows.

The core mechanisms enabling this are retrieval-augmented generation (RAG) over static prompting, persistent memory stores for project and user history, context compression and summarization pipelines, and external knowledge bases linked to agents -- such as [Karpathy's llm-wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), a curated knowledge base designed for LLM consumption.

## MCP: The USB-C of AI Tools

The Model Context Protocol (MCP) has become the standard for how models connect to tools and external systems. Built on simple structured messaging patterns, MCP enables rapid ecosystem adoption. The tool layer has become composable and interchangeable: instead of custom integrations for each system, tools can be plugged in via standardized MCP servers. The protocol is advancing quickly[^3], though some issues remain -- notably, high context-token usage when querying MCP tools can be expensive.

## A New Visual and Agentic Interface Paradigm

Text-only interaction is reaching its limits for complex outputs, multi-step workflows, and user interaction. AI systems increasingly generate interactive UI rather than just text. MCP Apps enable interactive applications rendered inside clients like Claude Desktop: MCP servers can return structured HTML-based interfaces, enabling forms, dashboards, data exploration, and tool-driven interaction inside chat environments.

Provider-specific implementations are proliferating: Claude Artifacts, OpenAI Canvas, Google Gemini Canvas, CopilotKit's Open Generative UI, and Omma all extend the traditional chatbot interface by rendering AI-generated content in dedicated, interactive user interfaces.

{% include image.html url="agentic_ai_intro_talk/kaparthy_visual_paradigm" description="Karpathy's tweet outlining his prediction for the paradigm shift in AI output format: from chat interfaces to HTML, then to interactive visuals, and eventually to fully interactive simulations and video."%}

Karpathy has articulated this shift explicitly[^4]: chat interfaces are only an early stage in human-AI communication. He predicts outputs will get progressively more visual, moving beyond HTML toward advanced interactive visual experiences and eventually fully interactive AI-generated simulations and video. The interface is becoming part of the model output itself -- not a separate layer. Agents are evolving from text generators into UI generators. Exciting, but it requires more capabilities, more tokens, and more compute.

## Agent Identity and Authentication

As agents increasingly perform user-specific actions, existing authentication mechanisms like OAuth are being extended into contexts they were not designed for. Authentication and authorization systems were built for human-driven, app-centric workflows. Agents operate on behalf of users but lack a stable, first-class identity model in the internet stack. Identity, permissions, and accountability for agents remain fundamentally unresolved.

{% include image.html url="agentic_ai_intro_talk/agent_authentication" description="Visualization of the current state of adapting OAuth and other authentication mechanisms built for human-driven apps to the context of autonomous AI agents acting on behalf of users."%}

## Small Models Moving Agentic AI to the Edge

There is a clear push toward on-device agentic systems instead of cloud-only execution, driven by latency, privacy, cost, and the desire for always-available agents. Karpathy has suggested that a ~1B parameter cognitive core may be sufficient for many agent tasks[^5]. This aligns with a trend: newer models from major providers are going very small, built natively for on-device, mobile, and browser environments. Examples include Gemma 4's smallest tier at ~2B parameters, Gemma 3's smallest tier at ~270M, and Qwen3.5 models down to ~0.8B parameters. Google also launched the Coral Board at Google I/O 2026, an edge development board that runs Gemma 3 270M locally, and Chrome now automatically downloads a ~4GB localized AI model to power native on-device features[^6].

Google's push into edge AI is a significant signal: the capabilities of small models running locally are no longer an academic curiosity but a product strategy backed by major infrastructure investment.

## Agents Operating at Superhuman Scale

While many people still think of AI as a chatbot, companies are already running agentic systems at scales that exceed human supervision. Peter Steinberger's team runs ~100 Codex agents continuously, burning through tokens worth ~$1.3 million in a month across 603 billion input tokens [^7]. Microsoft's MDASH system orchestrates over 100 agents for vulnerability discovery, with agents challenging and verifying one another [^8].

Cursor's FastRender project ran hundreds to thousands of frontier-model agents to develop a browser rendering engine from scratch -- browsers being among the most complex pieces of software to develop [^9]. The project amassed over 30,000 commits. Google's Antigravity team built a full OS from scratch using 93 subagents, 15,314 model calls, and over 339M input tokens [^10]. And Qwen3.7-Max wrote, compiled, profiled, and optimized a complex hardware architecture kernel entirely autonomously, running continuously over 35 hours with 1,158 tool calls across 432 kernel evaluations [^11].

These are not demonstrations of isolated capabilities. They are evidence that complex, long-horizon tasks are being executed by systems that operate beyond the scale of human oversight.

## Multi-Agent Systems

Complex tasks are increasingly decomposed across multiple specialized agents rather than handled by a single system. The Planner → Worker → Reviewer pattern is becoming dominant. Industry examples include Microsoft MDASH (>100 security agents), Cloudflare's vulnerability discovery harness with up to 50 parallel agents, Anthropic's Code Review with parallel reviewer agents, and OpenAI Codex designed for multi-agent workflows. At the conceptual level, systems like Paperclip model entire software organizations as teams of specialized agents -- engineering, product, design, review -- coordinated through structured workflows.

The multi-agent pattern addresses a core limitation of single-agent systems: the difficulty of maintaining focus, coherence, and correctness across long, complex tasks. By decomposing work across specialized agents, systems can achieve outcomes that no single agent could reliably produce alone.

## AI Training Becomes Agentic

Agentic systems are now being used to automate parts of AI training and research itself. Karpathy's [autoresearch](https://github.com/karpathy/autoresearch) demonstrates autonomous, self-improving agents that implement small iterative experiments for model optimization, following a Hypothesis → Experiment → Evaluation → Repeat loop. HuggingFace's [ml-intern](https://github.com/huggingface/ml-intern) "reads papers, finds datasets, trains models, and iterates until the numbers go up" -- in tests, it generated synthetic data points, upsampled and trained on them, and outperformed baselines [^12].

Karpathy moved to Anthropic to build a team that uses Claude to accelerate model development itself. The AI startup Recursive emerged from stealth with a $4.65 billion valuation, aiming to build AI systems that recursively improve themselves [^13]. Qwen's team integrated Qwen3.7-Max into their Reinforcement Learning monitoring, where the model acted as a reward hacking self-monitor, systematically identifying candidate hacking patterns, performing rule verification, counter-example mining, and iterative optimization.

AI is beginning to automate its own training pipeline. What this means for the trajectory of model development -- and who controls it -- remains an open question.

## Generative AI Stress-Testing Open Source

The influx of AI-generated content is placing enormous pressure on open source communities. Daniel Stenberg, creator of cURL, described it bluntly: "AI slop is DDoSing open source" [^14]. cURL's bug bounty program saw AI-generated bug reports spike to 8x the usual rate, triage becoming what Stenberg called "terror reporting," draining the will to live from the project's seven-person security team.

The OCaml project experienced a particularly illustrative incident: a 13,000-line (!) AI-generated pull request was submitted, incorrectly crediting researcher Mark Shinwell in file headers. When Shinwell responded to the misattribution with a lengthy "AI-written copyright analysis," he was asked whether he had written the analysis himself. His response: "Beats me. AI decided to do so and I didn't question it." The PR was rejected by maintainers, who noted that "AI-written code is more taxing than reviewing human-written code" and creates "a very real risk of bringing the Pull-Request system to a halt" [^15]. Complicating matters further, the incident was subsequently misreported by devclass.com, which incorrectly stated that Mark Shinwell was involved in the discussion -- a factual error that spread to Reddit and other forums.

{% include image.html url="agentic_ai_intro_talk/ocaml_pr_vibe_coded" description="Screenshot of the OCaml pull request showing the AI-generated code submission."%}

{% include image.html url="agentic_ai_intro_talk/ocaml_beats_me" description="Screenshot of the author's response when asked about the AI-written copyright analysis: 'Beats me. AI decided to do so and I didn't question it.'"%}

This case illustrates the broader problem: the signal-to-noise ratio in AI-generated submissions is deteriorating, and human review cannot scale with AI output. Irresponsible "vibe coding" is prone to creating not just low-quality contributions, but actual factual errors and security threats in codebases.

## AI as a Cybersecurity Actor

Frontier models like Claude Mythos Preview and GPT-5.5 have demonstrated the ability to autonomously discover vulnerabilities, develop exploits, and execute end-to-end attack chains [^16]. These capabilities lower the skill barrier for advanced cyberattacks and increase the scalability of exploitation. Anthropic's Project Glasswing systematically discovered 271 Firefox vulnerabilities in a single pass, including long-standing bugs [^17].

While current frontier deployments are limited to major labs and select partners, the underlying capabilities generalize and pose growing risk to smaller, less-resourced projects and organizations. AI systems are shifting from tools that assist security work to systems that can independently perform offensive cyber operations. The result is a rapidly expanding dual-use landscape where offensive capability scales faster than defensive readiness.

## The Cost Explosion

Agentic workflows consume massive amounts of tokens due to multi-step reasoning and repeated tool calls. This puts pressure on current pricing models. While inference costs are predicted to drop dramatically -- Gartner predicts >90% reduction by 2030 for large models [^18] -- the immediate pressure is driving a shift from subscription-based pricing to usage-based, token-based billing. GitHub Copilot already transitioned to token consumption-based billing [^19], and Google is moving to a compute-based consumption model [^20].

{% include image.html url="agentic_ai_intro_talk/Blablador_to_the_Rescue" description="Blablador as a cost- and privacy-conscious alternative in the face of exploding agentic AI token consumption."%}

Local models provide a partial escape hatch. As Simon Willison noted in his analysis of recent LLM developments, local models are becoming surprisingly competitive [^21]. There, he visualizes the rapid performance gains of open-weight models, illustrating that for many use cases, the return on investment of running models locally is increasing.

## Are Open-Weight Models Diminishing?

A concerning trend runs parallel to the cost issue. The technical lead of Alibaba's Qwen team, Junyang Lin, and several key contributors stepped down shortly after the Qwen 3.5 open-weight models were released. Multiple signals suggest that Qwen may reduce its emphasis on open-weight releases.

Frontier labs released open-weight models to drive adoption, build ecosystems, attract talent, and establish market leadership. But open-weight releases make direct monetization more difficult than API-based access. As competition intensifies and inference costs rise, pressure grows to generate revenue from model usage. Labs like OpenAI, Anthropic, and Google heavily subsidize training for their best models and offer them exclusively through proprietary APIs. Consequently, open-weight models typically trail closed frontier models by about 6--10 months on benchmarks on abstract reasoning tasks. But what about practical, creative tasks? Simon Willison's famous benchmark generating an SVG of a pelican riding a bicycle shows that newer open-weight models like Qwen3.6-35B-A3B can rival closed-model counterparts like Claude Opus 4.7, with results that are hard to distinguish or rank.

{% include image.html url="https://static.simonwillison.net/static/2026/5-minutes-llms/5-minutes-llms.026.jpeg" description="Simon Willison's benchmark comparing SVG generation of a pelican riding a bicycle across three models: Claude Sonnet 4.5, Claude Opus 4.7, and Qwen3.6-35B-A3B, showing that newer open-weight models, that can be run locally, are capable of producing near-identical quality outputs to proprietary ones. *Image from simonwillison.net, Copyright Simon Willison, licensed under [Apache License 2.0](https://static.simonwillison.net/static/2026/5-minutes-llms/5-minutes-llms.026.jpeg).*" %}



The long-term commitment of major providers to open-weight models remains uncertain, and the potential for growing dependency on proprietary providers is a genuine concern -- particularly for European research and industry.

## Agentic AI and the Scientific Publishing Crisis

Research is already under increasing pressure from exploding publication numbers. ICML received roughly 24,000 submissions in 2026, continuing a rapid growth trend that shows no signs of slowing.

{% include image.html url="agentic_ai_intro_talk/ICML_Submissions" description="Chart showing the rapid growth of ICML submissions over recent years, reaching approximately 24,000 in 2026."%}

AI tools make it easier to produce papers, reviews, and research artifacts at scale. Reviewers face increasing difficulty distinguishing high-quality work from AI-generated slop. The response from the community has been reactive: conferences like ICLR [^22], ACLRR [^23], and EMNLP [^24] are already piloting AI-assisted reviewing, essentially using the same technology that floods the pipeline to try to filter it. arXiv has introduced a 1-year penalty for authors submitting low-quality AI-generated content [^25].

If agents eventually conduct parts of research and other agents review the resulting work, what does this mean for scientific progress? This is not a speculative concern for the distant future. Research agents are already being developed that automate entire pipelines -- literature search, experimental design, data collection, analysis, and writing. Research may increasingly become a continuous, 24/7 process driven by autonomous systems.

## The Verification Bottleneck

This brings us to what I consider the central challenge: **the new bottleneck in agentic AI is verification, not generation**. Systems can produce outputs at scales that humans can no longer reasonably supervise. How do we verify outputs produced by systems operating at scale? How do we distinguish genuine breakthroughs from reward hacking, errors, or AI-generated noise?

The challenge is multi-faceted:

- **Context drift**: agents losing focus during long workflows, deviating from goals over extended interactions.
- **Reliable planning**: breaking complex tasks into effective steps, avoiding inefficient or incorrect plans.
- **Tool use**: robustly selecting and using the right tools under uncertainty, handling failures and noisy outputs.
- **Reward hacking**: agents optimizing metrics instead of objectives, producing seemingly correct results that mask underlying problems.
- **Benchmark integrity**: measuring real-world agent performance becomes increasingly controversial as models train on benchmark data.
- **Continuous learning**: learning from experience without catastrophic forgetting.
- **Human oversight**: outputs are exceeding human review capacity, and the problem will only get worse.

Research institutions are not prepared for autonomous AI. Regulatory systems were designed for static software, not adaptive autonomous systems acting continuously and at scale. Research society may require entirely new mechanisms for trust, provenance, and accountability.

## Where This Is Heading

Agentic AI is not a future technology anymore. The transition is already underway. The field is moving at incredible speed, and the gap between what agents can do and what our institutions, processes, and regulatory frameworks are prepared for continues to widen.

I suspect the answer to the question of whether science will turn into an AI slop factory or enter an era of dramatically accelerated discovery may depend less on model capabilities and more on whether we can build systems that are explainable, verifiable, and genuinely human-centric. The key challenge ahead is shaping how these systems integrate into science, institutions, and society -- and how we regulate them.



# References

[^1]: Witte, J., Bayer, S., Weber, I. (2026). *Use Cases for the Application of Generative Artificial Intelligence for Researchers: A Survey*. [hal-05463006](https://hal.science/hal-05463006).

[^2]: Precision AI Academy. 2026. *LLM Leaderboard 2026: 20 Models Ranked by MMLU, HumanEval & GPQA*. [precisionaiacademy.com](https://precisionaiacademy.com/llm-leaderboard).

[^3]: Agentic AI Foundation (AAIF). *MCP Is Growing Up*. [aaif.io/blog/mcp-is-growing-up/](https://aaif.io/blog/mcp-is-growing-up/).

[^4]: Karpathy on paradigm shift in AI output format. [x.com/karpathy/status/2053872850101285137](https://x.com/karpathy/status/2053872850101285137).

[^5]: Karpathy, Andrej. "~1B parameter cognitive core may be sufficient." [youtube.com/watch?v=UldqWmyUap4](https://www.youtube.com/watch?v=UldqWmyUap4).

[^6]: Google. *Chrome on-device AI model*. [support.google.com/chrome/answer/16961953](https://support.google.com/chrome/answer/16961953?hl=en).

[^7]: Steinberger, Peter. [x.com/steipete/status/2055346265869721905](https://x.com/steipete/status/2055346265869721905).

[^8]: Microsoft. *Defense at AI Speed: Microsoft's New Multi-Model Agentic Security System Tops Leading Industry Benchmark*. [microsoft.com/en-us/security/blog/2026/05/12/](https://www.microsoft.com/en-us/security/blog/2026/05/12/defense-at-ai-speed-microsofts-new-multi-model-agentic-security-system-tops-leading-industry-benchmark/).

[^9]: Lin, Wilson. *Cursor FastRender*. [github.com/wilsonzlin/fastrender](https://github.com/wilsonzlin/fastrender).

[^10]: Google. *Google Antigravity Built an OS*. [antigravity.google/blog/google-antigravity-built-an-os](https://antigravity.google/blog/google-antigravity-built-an-os).

[^11]: Qwen Team. *Qwen3.7-Max*. [qwen.ai/blog?id=qwen3.7](https://qwen.ai/blog?id=qwen3.7).

[^12]: HuggingFace. *ml-intern*. Synthetic data upsampling results. [linkedin.com/feed/update/urn:li:activity:7452298087814995968/](https://www.linkedin.com/feed/update/urn:li:activity:7452298087814995968/).

[^13]: Recursive. *Recursive raises $650M at $4.65B valuation*. [finsmes.com/2026/05/recursive-superintelligence-raises-650m-in-funding-at-4-65-billion-valuation.html](https://www.finsmes.com/2026/05/recursive-superintelligence-raises-650m-in-funding-at-4-65-billion-valuation.html).

[^14]: Stenberg, Daniel. *AI is DDoSing Open Source and Fixing Its Bugs*. [thenewstack.io](https://thenewstack.io/curls-daniel-stenberg-ai-is-ddosing-open-source-and-fixing-its-bugs/).

[^15]: OCaml pull request discussion. [github.com/ocaml/ocaml/pull/14369](https://github.com/ocaml/ocaml/pull/14369). DevClass coverage: [devclass.com](https://www.devclass.com/ai-ml/2025/11/27/ocaml-maintainers-reject-massive-ai-generated-pull-request/1728083).

[^16]: AI Security Institute. *Our Evaluation of OpenAI's GPT-5.5 Cyber Capabilities*. [aisi.gov.uk](https://www.aisi.gov.uk/blog/our-evaluation-of-openais-gpt-5-5-cyber-capabilities).

[^17]: Anthropic. *Project Glasswing Initial Update*. [anthropic.com/research/glasswing-initial-update](https://www.anthropic.com/research/glasswing-initial-update).

[^18]: Gartner. *Gartner Predicts That by 2030, Performing Inference on an LLM with 1 Trillion Parameters Will Cost GenAI Providers Over 90 Percent Less Than in 2025*. [gartner.com](https://www.gartner.com/en/newsroom/press-releases/2026-03-25-gartner-predicts-that-by-2030-performing-inference-on-an-llm-with-1-trillion-parameters-will-cost-genai-providers-over-90-percent-less-than-in-2025).

[^19]: GitHub. *Copilot token consumption-based billing*. [github.com/orgs/community/discussions/192948](https://github.com/orgs/community/discussions/192948).

[^20]: the-decoder.de. *KI wird teurer: Googles neues KI-Modell Gemini 3.5 Flash setzt den Trend fort*. [the-decoder.de](https://the-decoder.de/ki-wird-teurer-googles-neues-ki-modell-gemini-3-5-flash-setzt-den-trend-fort/).

[^21]: Willison, Simon. *The last six months in LLMs in five minutes*. [simonwillison.net/2026/May/19/5-minute-llms/](https://simonwillison.net/2026/May/19/5-minute-llms/).

[^22]: ICLR. *Leveraging LLM Feedback to Enhance Review Quality*. [blog.iclr.cc/2025/04/15/](https://blog.iclr.cc/2025/04/15/leveraging-llm-feedback-to-enhance-review-quality/).

[^23]: ACLRR AI-assisted reviewing experiment. [arxiv.org/abs/2604.13940](https://arxiv.org/abs/2604.13940).

[^24]: EMNLP 2026. *AI Reviewing Experiment*. [2026.emnlp.org/ai-reviewing-experiment/](https://2026.emnlp.org/ai-reviewing-experiment/).

[^25]: Dietterich, Tom. [x.com/tdietterich/status/2055000956144935055](https://x.com/tdietterich/status/2055000956144935055).
