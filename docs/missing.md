---
layout: page
title: Missed (for now)
---

<p class="message">
	In this page we list some of the detections that are not checked by Maracas. Some of them are intended, others are not reported due to technological limitations. This is not a complete list but it is the list of missed detections we are aware of after studying the Java Language Specification v8. If you identify new missed detections please be encouraged to report them in our issue tracker on GitHub.
</p>

## The `methodOverrides` relation of the M3 model does not consider multi-level inheritance
When Rascal builds the `methodOverrides` relation it only considers super methods that are owned by the immediate parent class. Methods that override an ancestor method owned by a class far in the hierarchy (different from the immediate parent) are not registered in the model. 

For example, class `A` extends class `B`, and class `B` extends class `C`. Suppose there is an abstract method `m()` declared in `C`. If `A` overrides `m()` the tuple `<|java+method:///pkg/A/m()|, |java+method:///pkg/C/m()|>` won't be included in the `methodOverrides` relation of the M3 model.

**Possible solution:** Modify `methodOverrides` computation on the Rascal side.


## Missing static constants at bytecode level
The JVM inlines static constants values in the bytecode. Then, their names are dropped by the compiler. Changes related to those fields are then missing.

For example, class `A` declares a static constant `CONS`. Class `B` has a method `m()` that accesses `CONS`. If `CONS` is removed from `A` we won't see this change at the bytecode level because the value has been inlined.

**Possible solution:** None


## Reporting `fieldNoLongerStatic` or `methodNoLongerStatic` without compilation error
Subtypes that access a static field or method of a parent class, can do so by directly accessing the entity without using the `<Class>.<entityName>` notation. Instead they directly accessed the inherited member. If the member is then changed to an *instance* entity no compilation error will raise. Nevertheless, we will always get a binary incompatible change. This is due to the use of different instructions at the bytecode level. In the case of instance accesses we will deal with instructions such as `getfield`, `putfield`, and `invokespecial`; while in the case of static accesses the expected instructions are `getstatic`, `putstatic`, and `invokestatic`. It does not matter which kind of access was used at the source code level.

For example, class `A` extends class `B`. Class `B` has a public static field `f`. Method `m()` in `A` accesses `f` without using the `<Class>.<entityName>` notation. Instead it accesses `f` by using the `<entityName>` or `super.<entityName>` notations. If `f` becomes non-static then no compilation error will be reported, however a linkage error will appear.

**Possible solution:** None. We also report binary incompatible changes.

## Reporting `fieldNowStatic` or `methodNowStatic` without compilation error

## Ignoring hierarchy inconsistency compilation error

## Reporting decases where an interface extends an annotation after a `classTypeChanged` change 

## Ignoring type conversion in `fieldTypeChanged` or `methodReturnTypeChanged` detections

## Ignoring existing `throws` clause in method declarations

## Reporting `fieldNowFinal` when no assignment is done