---
layout: page
title: Missed (for now)
---

<p class="message">
	In this page we list some of the detections that are not checked by Maracas. Some of them are intended, others are not reported due to technological limitations. This is not a complete list but it is the list of missed detections we are aware of after studying the Java Language Specification v8. If you identify new missed detections please be encouraged to report them in our issue tracker on GitHub.
</p>

## The `methodOverrides` relation of the M3 model does not consider multi-level inheritance

## Missing constants at bytecode level

## Reporting `fieldNoLongerstatic` or `methodNoLongerStatic` without compilation error

## Reporting `fieldNowStatic` or `methodNowStatic` without compilation error

## Ignoring hierarchy inconsistency compilation error

## Reporting decases where an interface extends an annotation after a `classTypeChanged` change 

## Ignoring type conversion in `fieldTypeChanged` or `methodReturnTypeChanged` detections

## Ignoring existing `throws` clause in method declarations

## Reporting `fieldNowFinal` when no assignment is done