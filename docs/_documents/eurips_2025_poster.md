---
layout: document
title: "Reproducibility by Design: A Modular Framework for Benchmarking Evolving Probabilistic AI Systems"
---
# Abstract
Benchmarking plays a central role in machine learning research, yet reproducibility, transparency, and comparability remain persistent challenges. These issues
become particularly severe when evaluating probabilistic or resource-intensive
systems such as large language models (LLMs). In these settings, experimental
outcomes depend on stochastic processes, hardware variability and availability,
and costly computations. This makes consistent and trustworthy evaluation
difficult to achieve. Reliable benchmarking frameworks are essential to maintain
scientific validity and support progress in an era where model capabilities and
APIs evolve rapidly.

These challenges are particularly evident in Uncertainty Estimation for LLMs,
where evaluations consist of multiple stochastic stages, such as model inference, intermediate computations, and metric aggregation, that each introduce
randomness. This compounded variability causes repeated runs of the same
benchmark to yield slightly different outcomes, complicating comparison and
reproducibility. Similar issues arise in prompt-based evaluation methods, where
benchmark logic depends on prompt templates or prompting strategies that may
interact differently as models advance. Our framework addresses these challenges
by decoupling benchmark logic from model execution and inference APIs, allowing benchmarks to be rerun seamlessly as new models and APIs emerge. This
design enables reproducible longitudinal studies, such as re-evaluating promptengineered uncertainty methods on future LLMs, while keeping benchmarks
up to date and analytically consistent with evolving model capabilities and
architectures.

To address these challenges, we present a modular framework for reproducible
benchmarking of probabilistic and resource-intensive machine learning models.
The framework was developed in the context of LLM uncertainty evaluation
but is designed for broader applicability across domains. Its core design principles are reproducibility, modularity, efficiency, and transparency. Individual
computation steps (e.g. data generation, method application, intermediate calculations, and aggregation) are implemented as dedicated modular components
with clear interfaces, allowing them to be modified or replaced without altering
the surrounding pipeline. Probabilistic model outputs and intermediate results
are cached and reused to enable deterministic re-evaluation without re-running
expensive inference. Internal resource management and caching are handled
through a transparent abstraction layer, ensuring consistency while minimizing
user overhead.
Beyond reproducibility, the framework supports qualitative and collaborative
analysis. Intermediate results are preserved for inspection of model failures,
enabling interpretability and error characterization. Cached model generations
and derived data can be shared among researchers, allowing others to apply new
methods without access to the original model or hardware. This decoupling
of model execution from evaluation logic lowers financial and computational
barriers, promotes open collaboration, and facilitates reproducible benchmarking
even under restricted-access conditions.
While motivated by the specific demands of Uncertainty Estimation in LLMs, the
proposed design generalizes to any benchmarking scenario involving probabilistic
outputs, multi-stage pipelines, or costly computations. It enables iterative
updates, efficient scaling across resources, and continuous adaptation to evolving
models and datasets. In doing so, it contributes to the foundations of trustworthy
and reproducible benchmarking, addressing a key bottleneck in contemporary
AI evaluation. The framework is currently integrated into ongoing large-scale
uncertainty benchmarking experiments and will be released as open-source
software

# Venue
Presented as a poster at the [Science of Benchmarking and Evaluating AI workshop](https://sites.google.com/view/benchmarking-and-evaluating-ai) (EurIPS 2025), held in Copenhagen, Denmark, on December 6, 2025. The workshop focuses on methods and practices for benchmarking and evaluating AI systems.
