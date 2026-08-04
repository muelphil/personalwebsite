---
layout: post
title: "AI in Education: The Little Annoying Brother of Science and How to Change That"
date: 2026-07-16 10:00:00 +0200
title_image: 'ai_and_education/title_image'
tags: [ "AI", "Education", "Agentic AI", "Pedagogy" ]
read_time: 11
abstract: "Reflecting on the intersection of teaching training and AI research: how agentic AI can transform education if we stop treating teaching as an afterthought and start building collaborative, experimentation-driven learning environments."
short_abstract: "An opinion piece on AI in education: from the knowledge explosion to democratized software, from scaffolding to reimagining what we validate in academic education."
---

I studied computer science and pedagogy side by side. Throughout my education, and now in my research on AI and agentic systems, I have repeatedly encountered a persistent gap: in research, we build on decades of theory, collaborate through published work, and stand on the shoulders of predecessors. In education, many of us wing it. No scientist would bat an eye at hearing that there is a dedicated research group on the Pacific Ocean studying the mating behaviour of a small population of whales. Yet I have had several people in academia express genuine surprise when I told them there is a science of teaching. They were fully unaware, and had mostly been improvising for their own courses and exercises. The gap between research and education is real, but AI could be the leverage point that might help close it.

This post collects my thoughts on what AI can do for education, where the real opportunities lie, and where I believe we need to change course.

## The Knowledge Explosion

In recent years, I have observed a hyperfocus in secondary education curricula on getting students ready for university, rather than ready to be valuable, engaged members of society. This narrows the educational mission to preparation for further study, and it saps intrinsic motivation. Students ask, "What do I need that for in my daily life?" and this is rarely a bad-faith question. More often, it comes from boredom and a missing connection to reality, the result of a curriculum focused on university preparation rather than building capabilities. It delivers knowledge, but not the skills of critical thinking.

This observation is linked to a fundamental problem: human knowledge grows faster than any individual can absorb it. The knowledge explosion leads to hyper-specialization, and trickles down through the entire educational system as complexity accumulates at every level. John Horgan touched on this in *The End of Science*[^1]: as scientific domains grow more complex, the frontier of discovery becomes inaccessible to anyone except a shrinking number of specialists.

One proposed counterargument is that the very systems created by advancing science eventually make complex knowledge more accessible -- through better tools, better visualizations, better abstractions. And I believe we are approaching exactly that inflection point. Educational technology, particularly AI, could take education to a new level. Maybe not today, but in the coming years, it could improve teaching and learning for everyone.

## Democratization of Software

AI is democratising an entire field: anyone with reasonable technical literacy can now build in a reasonable amount of time what previously required years of study in software engineering. This is a bigger shift than it might initially appear. Software is the capital of digitalization. It powers entire sectors, and until recently, building educational software was reserved for people who explicitly studied for it -- and who often lacked domain knowledge in the fields they were building software for.

An indicator of this shift is the rise of AI-powered clean-room reimplementations. In a traditional clean-room design, one team reverse-engineers a system to produce a specification, and a separate team builds a new implementation from that specification alone, without ever looking at the original source code. The idea is to create functionally equivalent software that is legally independent of the original. Historically, this process took teams of engineers months. Now, coding agents can do it in hours. The practical consequence is dramatic: software that previously took years to develop, and which often sits under restrictive or copyleft licenses that limit open use, can now be reimplemented from scratch and released under permissive open-source licenses. A famous recent example is the chardet 7.0 rewrite: the maintainer used Claude Code to produce a ground-up reimplementation of the LGPL-licensed library, releasing it under MIT with a measured code similarity of just 1.29% to the original [^2]. The legal question of whether this is legitimate is still unresolved, but the technical fact is clear: software is being democratized. The same capabilities that allow a seasoned maintainer to relicense a library will soon allow an educator to build tools they need for their classroom.

For education, this means teachers can build their own individualized material efficiently. Traditionally, software development followed a linear workflow: first scouting requirements, then conducting user studies, and finally implementing. Implementation took the longest, because writing code by hand is slow and requires specialized training. Now, agentic tools allow developers to describe what they need and get working software back. Rapid prototyping is possible directly in the classroom. Educators without a programming background can now produce interactive visualizations and experimentation environments through tools that allow AI systems to interact with external software. A good example is Grant Sanderson, who produces the well-known educational videos under the name 3Blue1Brown. Using his own open-source animation framework Manim [^3], he creates visual explanations of complex mathematical concepts, from calculus to linear algebra. Producing these videos originally required substantial coding knowledge and immense production effort. Today, small videos of this kind can be produced in a very short time using agentic AI to handle the implementation, making this form of visualization accessible to educators who are on constrained time. This is one example among many.

Open source is growing rapidly, and I hope open educational materials will follow the same path. The value of open source lies not just in free sharing, but in collaborative building -- multiple contributors improving, extending, and adapting work over time. That collaborative culture is largely absent in education. There is little to no interaction between teachers across schools, sometimes not even within a single school. Creative Commons licenses for education exist, but sharing and curating resources remains an open problem. We need to collaborate in education the way we collaborate in science. Right now, too many valuable resources are created in isolation and then lost.

This democratization also enables the creation of experimental learning environments, as advocated by multiple traditions in didactics. Piaget argued that students are active constructors of knowledge, not passive recipients, and learn like "little scientists" by exploring and testing [^4]. Aebli emphasized that learning happens through active construction from concrete action to mental representation to conceptual understanding [^5]. Bruner proposed that any subject can be taught in an intellectually honest form to any age group, provided the teacher acts as a scaffolder and learning progresses through enactive representations (actively engaging through hands-on interaction), iconic representations (visualizing those actions), and symbolic representations (working with abstract concepts and language) [^6]. AI and accessible software make it feasible to build environments that actually embody these principles at scale.

## Using LLMs to Learn About Didactics

There is a fundamental problem: educators in academia lack formal training in how to teach. While prospective teachers for schools undergo year-long training programs, lecturers and professors in higher education are simply expected to know how to do it. They were hired for their research expertise, not their pedagogical skills. LLMs can help bridge this gap. By asking the model to adopt an expert persona (also known as role prompting) you can have it review course material from a didactic perspective, evaluate structure, check for common misconceptions, suggest scaffolding strategies, or flag content that exceeds the target audience's zone of proximal development [^7]. This is not about replacing pedagogy with AI; it is about making the science of teaching available to people whose primary training is in their research domain.

## For AI, There Are No Dumb Questions

Many students fall behind simply because they cannot bring themselves to admit they do not understand something. This is deeply human, but destructive. It is exacerbated by systems that validate skill on a binary scale -- right or wrong -- and by teachers who do not have enough time to give each student the attention they need.

This problem goes deeper than the classroom. The pressure of always being correct corrodes the willingness to admit you lack knowledge, or that you might be wrong. This is core to exploratory research and hypothesis building: you need to be comfortable not knowing. In public, if admitting uncertainty carries a social cost, people stop doing it. I believe this dynamic also poisons political discourse, where the inability to say "I don't know" or "I was wrong" has become a structural problem, and as a result, people withdraw from discourse altogether.

An AI system does not judge. It allows students to phrase any question they might have been too embarrassed to ask in public, by removing the shame associated with missing knowledge or being behind. It will rephrase an explanation five times, approach it from different angles, and personalize without fatigue.

This connects directly to scaffolding, a concept central to constructivist education: the practice of supporting a learner just enough to keep them progressing, then gradually withdrawing support as they become independent. AI is a uniquely powerful tool for this, because it can provide that support on demand, at scale, and without judgment.

But two open problems remain. First, how do we ensure AI genuinely scaffolds rather than simply solving the student's work for them? The system must be constrained to guide learners toward discovering answers themselves, not handing them the solution. This is a challenge that requires careful design of AI-assisted learning experiences, with teachers retaining a critical curatorial role. Second, how do we translate the willingness to ask "dumb" questions into broader human discourse? If students grow comfortable questioning only a machine, there is a real risk they withdraw from interpersonal exchange altogether. The goal is not to replace human friction with AI convenience, but to use AI as a bridge back to more honest, open communication with each other. Both questions remain unsolved, and they demand deliberate pedagogical design.

## Personalization

AI enables personalization in two directions. First, toward learners: differentiation, meaning adapting material to individual students' starting levels, has long been a recognized necessity in education and takes a lot of time in preparation for teachers. Students arrive with varying prior knowledge, different learning paces, diverse educational backgrounds, and distinct ways of processing information. AI can adapt explanations, pacing, and examples to individual learners.

Second, toward teachers: teaching is an individual act. When I once saw someone try to use my workshop material verbatim, it felt like watching someone steal my car and drive it away, messing up all the gear shifts. Material alone is not enough. It requires someone who understands it, can motivate it, and can adapt it in real time. AI can help teachers personalize existing materials to their own style, rather than forcing a one-size-fits-all approach.

This observation actually undermines the "lecture halls will become empty" argument. Material alone does not teach. The human presence, the person who can explain, motivate, and model how to think, is what makes education work.

## Will AI Replace Educators?

Will students all just sit alone with laptops at home? Everyone learns differently, and resources that lack genuine educational value will lead to emptier lecture halls, students voting with their attendance. But the concept that students must passively consume all knowledge to understand something is long outdated.

Transfer learning, rhythm, and social interaction are critical to learning and motivation. Think about when you are most motivated to learn: is it sitting alone reading a paper at home, or attending a conference surrounded by people who are highly engaged and knowledgeable? The role of teachers has long been theorized to shift toward learning companions (*Lernbegleiter*, in German pedagogy), rather than being the primary source of knowledge.

Educators who consider themselves pure content delivery machines will be replaced. AI is infinitely more scalable at regurgitating facts. But learning is fundamentally social, not just cognitive. Through interaction with others we learn to communicate, resolve conflict, form ethical norms, and develop the interpersonal skills necessary for professional and civic life. AI adjusts too easily to what people want to hear. Discomfort, i.e. through attending lectures you find challenging, taking exercises where you might fail, or sitting through peer review, is a necessary part of growth.

There is a real risk that AI provides validation rather than genuine reflection, unless specifically prompted to do otherwise. It is comfortable to be told that you are right. Comfort does not improve you. Progress comes from self-assessment and iteration, and this is a core skill we need to explicitly teach.

## Other Fears and Open Questions

Will expertise erode? Will software engineers who learned heavily with AI be less knowledgeable than previous generations? Or will they be more capable, because AI lets them reach deeper into topics rather than getting stuck on basic implementation details? In computer science degrees especially, this question is urgent, and we do not yet have good empirical answers.

AI accessibility makes motivation and grading of student projects harder. When a student project can be completed with a few prompts, how do you assess whether the student actually engaged with the material? The answer may lie in reframing learning as experimentation and research, where students are evaluated on their ability to discover insights, articulate reasoning, and critically assess results, rather than on producing a polished final product.

AI may also counteract the phenomenon where everything gets harder as knowledge grows, by making the initial barrier to entry lower. This could mean more people enter fields they were previously priced out of by prerequisite complexity.

## Shifting Validation Targets

We need to shift what we validate in academic education. Currently, the validation markers are grades, publications, and research output. This works as a filter, but only for people who already possess high intrinsic motivation, self-assessment skills, and experimentation drive. It selects the already-fit.

Instead, we should build systems that encourage experimentation, self-assessment, and intrinsic motivation as targets themselves. Teaching these skills would produce more great researchers, not fewer, and importantly fewer dropouts. The students we lose right now might not lack ability. They might lack the self-regulated learning skills that the current system demands of them.

## Reimagining Education

I believe we need to reimagine education. Not as the "little annoying brother of science", the inconvenient obligation that researchers have to fulfill alongside their real work, but as a venue for passing on motivation and creating environments where experimentation and inquiry by students is genuinely encouraged. Looking at great educators, it is apparent that they do not just deliver content, but build spaces where curiosity happens through visualization, accessibility, and a question-driven, genetic approach to developing knowledge, where concepts are traced back to the original questions and discoveries that led to them.

But realizing this requires more than goodwill. Education requires funding, both regarding time available to educators, as well as financial support. Education is essential for training future researchers, yet funding almost exclusively goes toward new results. I would propose formalizing education as a first-class activity in research, for example through dedicated teaching workshops at conferences. An encouraging precedent is the VISxAI workshop at IEEE, which explicitly welcomes submissions that do not provide novel algorithmic insights, but instead build accessible projects that promote explainability in AI. Many of these projects are exceptional at making complex concepts tangible, and they could enhance learning experiences significantly if they reached educators. Teaching workshops at conferences would allow scientists to publish educational resources, from complete courses to interactive visualizations, as legitimate scholarly contributions.

## What You Can Do

If you are a researcher who teaches, there are concrete steps you can take right now. Review your course material through a didactic lens. Use AI to learn about pedagogy, by asking an LLM to evaluate your lecture structure, flag common misconceptions in your field, or suggest scaffolding strategies for difficult topics. You do not need a degree in education to benefit from decades of research on how people learn.

And if any of this resonates with you, I would be happy to connect and discuss!

# References

[^1]: Horgan, J. (1996). *The End of Science: Facing the Limits of Knowledge in the Search for Truth*. Four Walls Eight Windows. [Wikipedia: The End of Science](https://en.wikipedia.org/wiki/The_End_of_Science)

[^2]: Simon Willison's post on the chardet 7.0 rewrite: [simonwillison.net/2026/Mar/5/chardet/](https://simonwillison.net/2026/Mar/5/chardet/). The chardet maintainers used Claude Code to produce a ground-up MIT-licensed reimplementation of the LGPL-licensed library. On clean-room design: [Wikipedia: Clean room design](https://en.wikipedia.org/wiki/Clean_room_design).

[^3]: 3Blue1Brown -- Grant Sanderson's YouTube channel and the [Manim mathematical animation engine](https://www.3blue1brown.com/).

[^4]: Piaget, J. (1950). *The Psychology of the Child*. Basic Books.

[^5]: Aebli, H. (1980). *Der Lehrprozess: Allgemeine Aspekte Didaktischen Handelns*. Weinheim: Beltz.

[^6]: Bruner, J. S. (1960). *The Process of Education*. Harvard University Press.

[^7]: Vygotsky, L. S. (1978). *Mind in Society: The Development of Higher Psychological Processes*. Harvard University Press. The "zone of proximal development" is the gap between what a learner can do independently and what they can achieve with guidance. See also [Wikipedia: Zone of Proximal Development](https://en.wikipedia.org/wiki/Zone_of_proximal_development).
