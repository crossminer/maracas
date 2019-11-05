---
layout: page
title: Missed (for now)
---

<p class="message">
	In this page we list some of the detections that are not checked by Maracas. Some of them are intended, others are not reported due to technological limitations. This is not a complete list, but it is the list of missed detections we are aware of after studying the Java Language Specification v8. If you identify new missed detections, please be encouraged to report them in our issue tracker on GitHub.
</p>

---

## The `methodOverrides` relation of the M3 model does not consider multi-level inheritance
When Rascal builds the `methodOverrides` relation it only considers super methods that are owned by the immediate parent class. Methods that override an ancestor method owned by a class far in the hierarchy (different from the immediate parent) are not registered in the model. 

For example, class `A` extends class `B`, and class `B` extends class `C`. Suppose there is an abstract method `m()` declared in `C`. If `A` overrides `m()` the tuple `<|java+method:///pkg/A/m()|, |java+method:///pkg/C/m()|>` won't be included in the `methodOverrides` relation of the M3 model.

**Action:** Modify `methodOverrides` computation on the Rascal side.

**Status**: *TO-DO*

---

## Missing static constants at bytecode level
The JVM inlines static constants values in the bytecode. Then, their names are dropped by the compiler. Changes related to those fields are then missing.

For example, class `A` declares a static constant `CONS`. Class `B` has a method `m()` that accesses `CONS`. If `CONS` is removed from `A` we won't see this change at the bytecode level because the value has been inlined.

**Action:** None

**Status**: *Closed*

---

## Reporting `fieldNoLongerStatic` or `methodNoLongerStatic` without compilation error
Subtypes that access a static field or method of a parent class, can do so by directly accessing the entity without using the `<ClassName>.<entityName>` notation. Instead they directly accessed the inherited member. If the member is then changed to an *instance* entity no compilation error will raise. Nevertheless, we will always get a binary incompatible change. This is due to the use of different instructions at the bytecode level. In the case of instance accesses we will deal with instructions such as `getfield`, `putfield`, and `invokespecial`; while in the case of static accesses the expected instructions are `getstatic`, `putstatic`, and `invokestatic`. It does not matter which kind of access was used at the source code level.

For example, class `A` extends class `B`. Class `B` has a public static field `f`. Method `m()` in `A` accesses `f` without using the `<ClassName>.<entityName>` notation. Instead it accesses `f` by using the `<entityName>` or `super.<entityName>` notations. If `f` becomes non-static then no compilation error will be reported, however a linkage error will appear.

**Action:** None. We also report binary incompatible changes.

**Status**: CLOSED

---

## Reporting `fieldNowStatic` or `methodNowStatic` without compilation error
If an instance field or method becomes static do not expect compilation errors. This is mostly related to the fact that static members can be accessed through object (they are not encouraged though). However, this change always result in a binary incompatibility. This is due to the use of different instructions at the bytecode level. In the case of instance accesses we will deal with instructions such as `getfield`, `putfield`, and `invokespecial`; while in the case of static accesses the expected instructions are `getstatic`, `putstatic`, and `invokestatic`. It does not matter which kind of access was used at the source code level.

For example, method `m()` in class `A` initializes object `b` which is an instance of class `B`. Class `B` has a public method `n()`. Method `m()` in `A` accesses `n()` without using the `<ClassName>.<entityName>` notation. Instead it accesses `f` by using the `<entityName>` or `super.<entityName>` notations. If `f` becomes non-static then no compilation error will be reported, however a linkage error will appear.

**Action:** None. We also report binary incompatible changes.

**Status**: CLOSED

---

## Ignoring hierarchy inconsistency compilation error
When one of the ancestors of a subtype which is not its immediate parent is removed from its hierarchy the following compilation error is raised: 

> The hierarchy of the type `<ClassName>` is inconsistent. 

We do not report detections related to this compilation error. Instead we point out to the immediate subtype that is directly affected by changes in the parent type.

For example, class `A` extends class `B`, and class `B` extends class `C`. Is `C` is now final we report a detection pointing to `B` and no detection pointing to `A`, although we get the type hierarchy error mentioned above.

**Action:** None. We report the main cause of the problem (related to the immediate subtype).

**Status**: CLOSED

---

## Reporting cases where an interface extends an annotation after a `classTypeChanged` change 
In Java, interfaces can extend other interfaces. If it happens that one of the parent interfaces of an interface changes its type to an annotation, no error will pop up neither at the binary level nor at the source code level. However, at the M3 level we cannot know if a type is an annotation or an interface given that both of them are registered with the `java+interface` scheme.

For example, interface `I` extends interface `J`. In a new version of the Jar `J` is an annotation. We report a detection, even though there is no incompatibility error.

**Action:** Store annotation data at the M3 level.

**Status**: *TO-DO*

---

## Ignoring type conversion in `fieldTypeChanged` or `methodReturnTypeChanged` detections
A field or method can change its type in a new version of a Jar. At first glance, this change seems to be breaking in all scenarios. However, it could happen that the change does not produce any error due to Java capability of supporting implicit type conversion. According to *JLS Chapter 5*:

> [..] the rules determining whether a target type allows an implicit conversion vary depending on the kind of context, the type of the expression, and, in one special case, the value of a constant expression.

In Maracas we do not exclude type conversion cases from the detections set. This is something that must be tackled in the future.

For example, field `f` is declared as a `long`. The field is assigned to a variable `v` of type `long` (i.e. `long v = f;`). In a new version of the Jar `f` is changed to an `int`. After this change, `long v = f;` raises no error thanks to Java type conversion.

**Action:** Consider type conversion cases at the detections level in Maracas.

**Status**: *TO-DO*

---

## Ignoring existing `throws` clause in method declarations
When an unchecked exception becomes a checked exception, all methods throwing such exception should include it in their `throws` clause. However, it could happen that previous unchecked exceptions are added to the `throws` clause. Thus, we need to confirm that the exception is not already included in the list. However, we do not count with this information at the M3 level. Thus, Maracas report all methods that have a dependency on the modified exception. This is something that must be tackled in the future.

For example, exception `E` is an unchecked exception. It is used by method `m()` of class `A` in the following way:

```java
public void m(boolean flag) throws E {
	if (flag) {
		throw new E(); 
	}
}
```

Although there is no need to add `E` to the `throws` clause of `m()` the developer added this line. Then, if `E` is now considered a checked exception no error pops up because it is already included in the corresponding clause.

**Action:** Add exceptions handling information at the M3 level.

**Status**: *TO-DO*

---

## Reporting `fieldNowFinal` when no assignment is done
If a field is labeled as `final` it means that no new assignment can be made besides from the one done in a static initializer or in the constructor of the owner class. Maracas does not count with this information at the M3 level, then we report all cases where there is an access of the modified field. This is something that must be tackled in the future.

For example, the public field `f` in class `A` of type `int` is accessed by method `m()` in class `B`, as shown below.

```
public void m() {
	f = 0;
}
```

If it happens that `f` is declared as `final` in a new version of the Jar, Maracas reports a detection pointing to method `m()`. This will be done, even though there is no assignment that triggers any error in the code.

**Action:** Get this information from the bytecode level.

**Status**: *TO-DO*