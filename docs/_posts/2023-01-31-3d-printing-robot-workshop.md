---
layout: post
title: "3D Printing as a Didactic Tool – Repairing a Robot in the Classroom"
abstract: "A one-day workshop that uses 3D modeling and printing to teach problem-solving, abstraction, and core principles of computer science education"
short-abstract: "A one-day workshop that uses 3D modeling and printing to teach problem-solving, abstraction, and core principles of computer science education"
tags: [ "Computer Science", "3D Printing" ]
date:   2023-01-31 10:31:42 +0200
title-image: 'Robot/title_image'
read_time: 4
carousels:
  - images:
      - image: Robot/robot_broken
      - image: Robot/robot_happy
  - images:
      - image: Robot/blueprint_arm
      - image: Robot/blueprint_head
---

As part of my teacher training in computer science education, I designed and conducted a one-day workshop aimed at students in grades 7 to 9. The goal of the workshop was to provide a hands-on introduction to 3D printing and digital modeling while deliberately focusing on computational and informatic ways of thinking, rather than on software operation alone.

For this purpose, I designed a modular 3D robot in advance. The robot consisted of individual components and featured movable joints, allowing it to be assembled and disassembled in different ways. This modular structure was a deliberate didactic choice: it reflects the fundamental computer science principle of breaking down complex systems into manageable parts, and it conceptually prepared students for the later modeling task.

### Narrative framing and problem orientation

The workshop began with a narrative framing: students were introduced to the problem that the robot’s arm was broken and needed to be repaired. This scenario was supported by a short video clip from the film _Wall-E_, in which the robot loses an arm.

{% include gallery.html height="10" unit="vh" number="1" ui-color="black" description="The robot model with the missing arm (left) and again after being repaired (right)." wide=false %}

From a didactic perspective, this framing served several purposes. Narrative and film-based introductions are known to be highly motivating, and they help establish a clear, problem-oriented learning goal. Rather than learning abstract techniques, students worked toward a concrete objective: repairing the robot.

At the same time, the scenario highlighted one of the key societal opportunities of 3D printing: the cost-effective repair of products, which can increase maintainability and extend the lifespan of devices. In this way, the workshop connected technical learning with a real-world and sustainability-related context.

### Haptic learning and multiple representations

Each student received a small version of the robot with a missing arm. In addition, a large-scale model (10:1) was available as a shared reference. These physical objects were intentionally included to support enactive learning: learning through direct interaction with tangible artifacts. I also prepared blueprints that were to be used for the modelling process by the students.

{% include gallery.html height="100" unit="vh" number="2" ui-color="black" description="Digital versions of
the blueprints for the robot arm (left) and the robot head (right)." wide=true %}

Throughout the workshop, students worked across multiple levels of representation:
* the real object (the physical robot),
* an iconic representation (printed blueprints),
* and a symbolic representation (the digital model in BlocksCAD).

This progression supports understanding, especially for heterogeneous learner groups, and aligns with well-established representation models by Jerome Bruner.

### Software choice and cognitive load reduction

For digital modeling, I chose [BlocksCAD](https://blockscad3d.com/editor/) instead of a text-based CAD tool. This decision was made to reduce extraneous cognitive load caused by syntax and complex interfaces, allowing students to concentrate on problem-solving and modeling concepts instead.

In the first phase of the workshop, students were introduced to the basics of 3D printing and the software environment.

{% include video.html url="Robot/slicing" description="A video demonstrating the slicing process in PrusaSlicer, illustrating the technical functionality and limitations of 3D printing to students." autoplay="true" loop="true" muted="true" %}

They then learned about primitive shapes, structural decomposition, and set operations (union, difference, intersection). These concepts convey modularization as a core principle of computer science and provide the conceptual foundation needed to achieve the workshop’s main goal.

### Cognitive activation instead of step-by-step imitation

A central didactic objective of the workshop was cognitive activation, which is widely regarded as a key characteristic of high-quality instruction. Rather than following predefined instructions or copying given dimensions, students were required to measure dimensions themselves using blueprints or the physical model make assumptions about proportions and geometry iteratively test and refine their digital models.

This approach encouraged students to make independent decisions, reflect on their assumptions, and actively validate their solutions. In this way, 3D printing became a medium for thinking rather than an end in itself.

### The goal: repairing and customizing the robot

The primary goal of the workshop was to “repair” the robot by digitally modeling the missing arm and, when time permitted, printing it on-site. Students were allowed to take their printed parts home, which further increased motivation and a sense of ownership.

To support differentiation, more advanced students could alternatively model the robot’s head, a significantly more complex component. This open task structure helped address varying skill levels and prevented both under- and over-challenging students.

### Scaffolding and gradual release of responsibility

The support structure of the workshop was carefully designed. At the beginning, students worked with substantial guidance to become familiar with the tools and concepts. During the modeling phase, this support was adapted to individual needs and gradually reduced.

This approach is known as scaffolding: learners are initially supported and then progressively empowered to solve problems independently. In a final open phase, students were free to design additional robot parts or entirely new components, such as alternative heads or custom modules.

### Modeling, validation, and iteration

One of the distinctive didactic strengths of 3D printing is that it makes modeling as an iterative process tangible. Students experienced firsthand that models rarely work perfectly on the first attempt and must be tested, evaluated, and refined.

This understanding of modeling plays a central role in both mathematics education (modeling real-world situations) and computer science education (abstraction, formalization, and validation). The workshop therefore offered an interdisciplinary learning experience that fostered both problem-solving skills and abstract thinking.

### Download the Model

The materials used in the workshop (the modular robot model, the digital blueprints, and the BlocksCAD files) are freely available for download. Educators and students can access and adapt these resources via the following link:

{% include link_block.html
image="Robot/thingiverse"
title="Thingiverse - Modular Robot with Movable Joints"
text="Here you can download the stl files, blueprints and the BlockSCAD xml files for adjustments."
url="https://www.thingiverse.com/thing:6026222
"
%}


