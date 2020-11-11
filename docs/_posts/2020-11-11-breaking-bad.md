---
layout: post
title: Breaking Bad?
---

The content presented in this website accompanies the paper "Breaking Bad? Semantic Versioning and Impact of Breaking Changes in Maven Central" authored by Lina Ochoa, Thomas Degueule, Jean-Rémy Falleri, and Jurgen Vinju.
The study is an external and differentiated replication study of the paper ["Semantic Versioning and Impact of Breaking Changes in the Maven Repository"](https://jstvssr.github.io/assets/pdf/semantic-versioning-maven.pdf) presented by Steven Raemaekers, Arie van Deursen, and Joost Visser.

In the study, we consider 31 types of breaking changes as reported on the Java Language Specification Java SE 8 Edition, and the blog post ["Evolving Java-based APIs"](https://wiki.eclipse.org/Evolving_Java-based_APIs) authored by Jim Des Rivières, namely:

* Interface added
* Interface removed
* Class less accessible
* Class no longer public
* Class now abstract
* Class now final
* Class removed
* Class type changed
* Constructor less accessible
* Constructor removed
* Field less accessible
* Field more accessible
* Field no longer static
* Field now final
* Field now static
* Field removed
* Field type changed
* Method abstract added to class
* Method abstract now default
* Method added to interface
* Method less accessible
* Method more accessible
* Method new default
* Method no longer static
* Method now abstract
* Method now final
* Method now static
* Method removed
* Method return type changed
* Superclass added
* Superclass removed

Details on how we detect these breaking changes are provided [here](https://crossminer.github.io/maracas/detections/).