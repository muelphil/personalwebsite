---
layout: document
title: "Uncertainty Estimation of Large Language Model Replies in Natural Sciences"
---

# Abstract

Large language models (LLMs) are increasingly used in many fields such as software develop-
ment, healthcare, education, and customer service. In the natural sciences, LLMs could help
accelerate research by assisting with literature reviews, data analysis, and understanding com-
plex concepts across multiple fields. However, a major challenge is that LLMs can produce
confident yet incorrect answers, known as "hallucinations", even when there is significant un-
derlying uncertainty. This is especially problematic in scientific research, where accuracy and
sound reasoning are essential for scientific inference. Uncertainty Quantification aims to ad-
dress this challenge by providing metrics that quantify how reliable generated answers are,
which can help users decide when additional fact-checking is needed or when to use larger
models for difficult tasks.

Although uncertainty quantification is well established in other areas of machine learning,
its application to LLMs remains in its early stages. While some uncertainty quantification
techniques use information theory principles like entropy, eccentricity, and perplexity without
focusing on language-specific details, they have not been extensively validated for LLMs, and
newly proposed metrics remain sparsely evaluated. Moreover, current benchmarks tend to
focus on very specific tasks and domains, raising questions about their generalizability and
applicability to scientific question answering that involves reasoning and specialized notation.

As a result of this research, various theoretical approaches to uncertainty quantification of
LLM responses are qualitatively assessed. Subsequently, a subset of metrics representing dif-
ferent approaches is benchmarked for reliability in estimating uncertainty in scientific ques-
tion answering. It was found that token probabilities, while easy to obtain, often become less
informative after instruction tuning due to polarization effects, particularly in tasks requiring
complex reasoning. Among the evaluated uncertainty metrics, only the Frequency of Answer
metric — based on consistency across multiple generations — demonstrated robust calibration
across diverse datasets, despite its high computational cost. Other metrics, particularly those
based on token-level or verbalized probabilities, exhibited poor reliability in broader scientific
question answering. To support reproducible and scalable research, an extensible benchmark-
ing framework was reengineered, providing a foundation for future studies in uncertainty
quantification for LLMs.

# Venue

Presented as a poster at the Helmholtz AI Conference (HAICON 25), hosted by Helmholtz AI in Karlsruhe, Germany, from
June 3 to June 5, 2025. The poster
was [awarded 2nd prize for Best Poster in an audience vote](https://www.hzdr.de/db/!News.AllNews?pSelMenu=0&pSelId=1704&pNid=530),
selected from a total of 200 presented posters.


# Venue
## Venue
### Venue
#### Venue
##### Venue

