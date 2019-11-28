---
layout: page
title: Detections
---
<p class="message">
	In this page we list the detections that are identified by Maracas. These detections are computed based on the Java Language Specification v8. If you identify new missed detections please be encouraged to report them in our issue tracker on GitHub.
</p>

## Annotation Deprecated Added
A type, method, or field is tagged with the `@Deprecated` annotation. This is neither a binary nor source incompatible change.

**Detection**

1. Client types that extend or implement deprecated API types.
2. Client methods and fields that depend on deprecated API types.
3. Client methods that invoke or override deprecated API methods (including constructors).
4. Client methods that access deprecated API fields.
5. Client methods that invoke deprecated API methods or access deprecated API fields of a supertype through the `super` keyword. 
6. Client methods that invoke deprecated API methods or access deprecated API fields of a supertype without the `super` keyword.

<p class="message"> 
  We consider all direct subtypes of the type that owns a deprecated method or field, which do not shadow the target entity.
</p>

For example, there is an API type `api.A` that contains the method `mA()`. There is also a client type `client.C` that contains the method `mC()`, which invokes `mA()`. If `api.A` is annotated with `@Deprecated` then `mA()` is also tagged as deprecated, and the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  annotationDeprecatedAdded(binaryCompatibility=true,sourceCompatibility=true)
)
```

<p class="message">
  Due to type erasure, uses of deprecated types as type parameters cannot be detected."
</p>

---

## Field Less Accessible
The field or its parent class is less accessible. 
Some client entities are not able to access this field anymore. 
The following table provides the less access permited situations in Java (cf. *JLS 13.4.7*). 
We report which of them might break client code, and which exceptions must be considered regarding fields use.

| Source | Target | Detection |
|--------|--------|-----------|
| `public` | `protected` | All field accesses except if they are made from a subtype of the owning class. Exceptions related to the `public` to `package-private` change are also considered. |
| `public` | `package-private` | All field accesses except if they are made from a type in a package with the same qualified name as the constructor owning type. |
| `public` | `private` | All field accesses. |
| `protected` | `package-private` | All field accesses except if they are made from a type in a package with the same qualified name as the constructor owning type. |
| `protected` | `private` |  All field accesses. |
| `package-private` | `private` |  All field accesses. |

**Detection**

1. Client methods within type `T` accessing a field of the type `S`, where: i) `T` is not a subtype of `S`; ii)`T` is not located in a package with the same qualified name as the parent package of `S`; and iii) the field in `S` or `S` itself goes from `public` to `protected`. 
2. Client methods within type `T` accessing a field of the type `S`, where: i) `T` is not located in a package with the same qualified name as the parent package of `S`; and ii) the field in `S` or `S` itself goes from `public` to `package-private` or from `protected` to `package-private`. 
3. Client methods within type `T` accessing a field of the type `S`, where the field in `S` goes from `public` to `private`, or from `protected` to `private`, or from `package-private` to `private`.

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a `public` field `f`. 
Assume `m()` accesses `f`, and `client.C` is not a subtype of `api.A`. 
If the visibility of `m()` is changed to `protected`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldLessAccessible(binaryCompatibility=false,sourceCompatibility=false)
)
```

<p class="message">
  Due to type erasure, uses of deprecated types as type parameters cannot be detected."
</p>

---

## Field No Longer Static
A field goes from `static` to `non-static` becoming an instance field. The field cannot be accessed through its class, instead it should be accessed through an object of the corresponding type. 

**Detection**

1. Client methods accessing a field that is no longer `static`.

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a class field `f`. Assume `m()` accesses `f` in a static manner (i.e. `A.f`). If `f` is changed to `non-static` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Field Now Final
A field goes from `non-final` to `final`, thus the field value cannot be modified. Client code breaks if ther is an attempt to assign a new value to the field.

**Detection**

1. Client methods accessing and assigning a new value to a field that is now `final`.
2. Client methods accessing through the `super` keyword a supertype field that is now `final` and assigning it a new value.
3. Client methods accessing without the `super` keyword a supertype field that is now `final` and assigning it a new value.

<p class="message">
  We consider all direct subtypes of the type that owns the modified field, which do not shadow the target field."
</p>

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a field `f`. Assume `m()` accesses `f` and assigns a new value to `f`. If `f` is declared as `final` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Field Now Static
A field goes from `non-static` to `static`. 
This results in an `IncompatibleClassChangeError` at linking time. 
The problem rises given that the JVM uses two different instructions to access fiels, `getfield` and `getstatic`. 
The former is used to access objects fields and the later to access static fields. 
Client code must be recompiled to get rid of the issue (cf. *JLS 13.4.10*).

**Detection**

1. Client methods accessing a field that is now `static`.
2. Client methods accessing a supertype field that is now `static` through the `super` keyword.
3. Client methods accessing a supertype field that is now `static` without the `super` keyword.

<p class="message">
  We consider all direct subtypes of the type that owns the modified field, which do not shadow the target field."
</p>

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a field `f`. Assume `m()` accesses `f`. If `f` is declared as `static` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldNowFinal(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Field Removed
A field is removed from its parent class. Client projects are not able to access it anymore.

**Detection**

1. Client methods accessing a field that is removed due to its parent type removal.
2. Client methods accessing a field that is removed from an API type.
3. Client methods accessing a removed supertype field through the `super` keyword.
4. Client methods accessing a removed supertype field without using the `super` keyword.
5. Transitive detections affecting all subtypes are reported with the *Field Removed in Superclass* change. 

<p class="message">
  `javac` inlines constant values, thus this type of field access is lost."
</p>

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a field `f`. Assume `m()` accesses `f`. If `f` is removed from `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Field Removed In Superclass
A field is removed from a supertype class. Subtypes are not able to access it anymore.

**Detection**

1. Client methods accessing a field that has been inherited from a supertype and whose type has been removed.
2. Client methods accessing a field that has been inherited from a supertype and that has been removed from the corresponding type.
3. Client methods accessing a field that has been inherited from a supertype through the `super` keyword.
4. Client methods accessing a field that has been inherited from a supertype without using the `super` keyword.

<p class="message">
  We consider all direct subtypes of the type that owns the removed field, which do not shadow the target field."
</p>

For example, there is an API type `api.A` that extends from the API type `api.SuperA`. The later declares a field `f`. There is also a client type `client.C` that extends `api.A`. Type `client.C` has a method definition `m()`. Assume `m()` accesses `f`. If `f` is removed from `api.SuperA`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/SuperA/f|,
  fieldAccess(),
  fieldRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Field Static And Overrides Static
A client type overrides a static supertype field with a non-static field. This means that a non-static field with the same name is declared within the subtype class.

"If a new field of type X with the same name as f is added to a subclass of S that is a superclass of T or T itself, then a linkage error may occur."

---

## Field Type Changed
The type of the field has changed. 

TODO: what kind of binary error do we get?
Check conversion cases in assignment, invocation, String, casting, and numeric contexts (cf. *JLS 5.1*). Check the following table:

| Conversion type     | Description| Breakage      |
|---------------------|------------|---------------|
| Identity | Type `T` to type `T` | Never|
| Widening primitive  | Smaller primitive type to wider primitive type| Never |
| Narrowing primitive | Wider primitive type to smaller primitive type| Sometimes (1) |
| Widening reference | Subtype `T` to supertype `ST` | Never |
| Narrowing reference | Supertype `ST` to subtype `T` | Sometimes (2) |
| Boxing | Primitive type `P` to wrapper reference type `R` | Never |
| Unboxing | Wrapper reference type `R` to primitive type `P` | Sometimes (3) 
| Unchecked | Interface type `G` to parameterized type `G<T1,..,Tn>` | Sometimes (4) | 

(1) It will result in a breaking change if no explicit cast is present in the old API version.
(2)
(3) Long, Float
(4) Type erasure 

**Detection** 
 
1. Client methods accessing the field with the modified type.
2. Client methods accessing a modified supertype field through the `super` keyword.
4. Client methods accessing a modified supertype field without using the `super` keyword.

<p class="message">
  We consider all direct subtypes of the type that owns the removed field, which do not shadow the target field."
</p>
 
For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a field `f` of type `T`. Assume `m()` accesses `f`. If the type of `f` is changed to type `R`, then the following detection is reported:
 
```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldTypeChanged(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Constructor Less Accessible
The constructor or its parent class is less accessible. 
Client entities cannot create objects with this method.
The following table provides the less access permited situations in Java (cf. *JLS 13.4.7*). 
We report which of them might break client code, and which exceptions must be considered regarding constructors use.

| Source | Target | Detection |
|--------|--------|-----------|
| `public` | `protected` | All invocations except if the invocation is made from a subtype of the owning class. Exceptions related to the `public` to `package-private` change are also considered |
| `public` | `package-private` | All invocations except if the invocation is made from a type in a package with the same qualified name as the constructor owning type |
| `public` | `private` | All invocations of the method |
| `protected` | `package-private` | All invocations except if the invocation is made from a type in a package with the same qualified name as the constructor owning type |
| `protected` | `private` |  All invocations of the method |
| `package-private` | `private` |  All invocations of the method |

**Detection**

1. Client methods within type `T` invoking a constructor of type `S`, where: i) `T` is not a subtype of `S`; ii)`T` is not located in a package with the same qualified name as the parent package of `S`; and iii) the constructor of `S` or `S` itself goes from `public` to `protected`. 
2. Client methods within type `T` invoking a constructor of type `S`, where: i) `T` is not located in a package with the same qualified name as the parent package of `S`; and ii) the constructor of `S` or `S` itself goes from `public` to `package-private` or from `protected` to `package-private`. 
3. Client methods within type `T` invoking a constructor of type `S`, where the constructor of `S` goes from `public` to `private`, or from `protected` to `private`, or from `package-private` to `private`.


For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a `public` constructor `A()`. Assume `m()` invokes `A()` to create an object of type `api.A`. If the access modifier of `A()` is changed to `private`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+constructor:///api/A/A()|,
  methodInvocation(),
  constructorLessAccessible(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Constructor Removed
If the constructor or the parent class is removed, this issue is reported. Client projects are not able to create objects with the corresponding method.

**Detection** 

1. Client methods invoking a constructor that is removed due to its parent type removal.
2. Client methods invoking a constructor that is removed from an API type.
3. Client constructors invoking an supertype constructor through the `super` keyword. 

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a constructor `A(int)`. Assume `m()` invokes `A(int)` to create an object of type `api.A`. If `A(int)` is removed from `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+constructor:///api/A/A(int)|,
  methodInvocation(),
  constructorRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Abstract Added In Superclass
An abstract method is added to a superclass and no implementation is provided in (maybe part of) the API hierarchy. 
This change is reported only if subtypes are abstract. 
Client types affected by this issue extend one of the subtypes of the superclass where the abstract method was added.
We do not provide detections linked to this type of change.
Instead we detect this and more general cases through the *Method Abstract Added To Class* change.

---

## Method Abstract Added To Class
A new abstract method is added to a class.
All non-abstract client classes extending the modified class or an abstract subtype will break, given that the definition of the target method is missing.
This will result in a compilation error (i.e. source incompatible).
However, at the binary level, no brekage is detected given that there cannot be calls to the new method when using the old version of the API (cf. *JLS 13.5.3.*).
In addition, the JVM does not check if there are missing method implementations at linking time. 

**Detection**

1. Non-abstract client classes extending the class that owns the new abstract method.
2. Non-abstract client classes extending a subtype of the class that owns the new abstract method.

For example, there is a client type `client.C` that extends the API abstract class `api.A`. Assume `api.A` declares a new abstract method `m()` in its body, then the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+method:///api/A/m()|,
  extendss(),
  methodAddedToClass(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Method Abstract Now Default
An abstract method in an interface is now declared as a default method. 
As stated in the *JLS*, this change results in a `IncompatibleClassChangeError` linkage error only in the following scenario.
Type `T` implements interfaces `I` and `J`.
`I` is not a subinterface of `J` and visceversa.
`J` has a default method `m()`.
Now, we add a new default method in `I` with the same signature and return type of `m()`.
Suppose there is an invocation of `m()` in `T` that does not follow the form `J.super.m()`.
With this change `T` will link without error but once the invocation to `m()` is triggered an error is thrown.
In any case, this change might result in unpredictable behaviour or a compilation error (c.f. *JLS 13.5.6*).

**Detection**

1. Client abstract classes implementing two or more interfaces, where at least one of the interfaces has a method with the same signature of the now default method; and the client class has no new method definition with such signature.

<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

<p class="message">
  Behavioural changes are not being reported. For instance, no detection is reported regarding invocations of the overriden method.
</p>

For example, there is a client type `client.C`, and two API interfaces `api.I` and `otherapi.J`. 
The type `client.C` implements both `api.I` and `otherapi.J`. 
Suppose `api.I` and `otherapi.J` declare an abstract method `m()` (each one of them has it own definition).
If the API evolves and `api.I` changes `m()` from an abstract to a default method, and `client.C` has no method definition of `m()`, then the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+method:///api/I/m()|,
  implements(),
  methodAbstractNowDefault(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Added To Interface
A new method is added to an interface.
All client classes implementing the interface will break given that the implementation of the target method is missing.
This will result in a compilation error (i.e. source incompatible).
However, at the binary level, no brekage is detected given that there cannot be calls to the new method when using the old version of the API (cf. *JLS 13.5.3.*).
In addition, the JVM does not check if there are missing method implementations at linking time. 

**Detection**

1. Client classes implementing the interface that owns the new method.

For example, there is a client type `client.C` that implements the API interface `api.IA`. Assume `api.IA` declares a new method `m()` in its body, then the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+method:///api/IA/m()|,
  implements(),
  methodAddedToInterface(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Method Less Accessible
The method or its parent class is less accessible. 
Some client entities are not able to invoke this method anymore. 
The following table provides the less access permited situations in Java (cf. *JLS 13.4.7*). 
We report which of them might break client code, and which exceptions must be considered regarding methods use.

| Source | Target | Detection |
|--------|--------|-----------|
| `public` | `protected` | All method invocations and overrides except if they are made from a subtype of the owning class. Exceptions related to the `public` to `package-private` change are also considered. |
| `public` | `package-private` | All method invocations and overrides except if they are made from a type in a package with the same qualified name as the constructor owning type. |
| `public` | `private` | All method invocations and overrides. |
| `protected` | `package-private` | All method invocations and overrides except if they are made from a type in a package with the same qualified name as the constructor owning type. |
| `protected` | `private` |  All method invocations and overrides. |
| `package-private` | `private` |  All method invocations and overrides. |

**Detection**

1. Client methods within type `T` invoking or overriding a method of the type `S`, where: i) `T` is not a subtype of `S`; ii)`T` is not located in a package with the same qualified name as the parent package of `S`; and iii) the method in `S` or `S` itself goes from `public` to `protected`. 
2. Client methods within type `T` invoking or overriding a method of the type `S`, where: i) `T` is not located in a package with the same qualified name as the parent package of `S`; and ii) the method in `S` or `S` itself goes from `public` to `package-private` or from `protected` to `package-private`. 
3. Client methods within type `T` invoking or overriding a method of the type `S`, where the method in `S` goes from `public` to `private`, or from `protected` to `private`, or from `package-private` to `private`.

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a `public` method `mA()`. 
Assume `mC()` invokes `mA()`. 
If the visibility of `mA()` is changed to `package-private`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  methodLessAccessible(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method More Accessible
The method is more accessible than its previous version. 
Client types overriding such methods will break if the visibility of their own declaration is lower than the API definition.

**Detection**

1. Client methods within type `T`overriding a method of the type `S`, where the new method declaration in `T` is less accessible than the corresponding definition in `S`.

For example, there is an API type `api.A` with a `protected` method `m()`.
The later is overriden in client type `client.C` with a `protected` visibility. 
If the visibility of `m()` is changed to `public` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+method:///api/A/m()|,
  methodOverride(),
  methodMoreAccessible(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method New Default
A new default method is declared in an interface.
As stated in the *JLS*, this change results in a `IncompatibleClassChangeError` linkage error only in the following scenario.
Type `T` implements interfaces `I` and `J`.
`I` is not a subinterface of `J` and visceversa.
`J` has a default method `m()`.
Now, we add a new default method in `I` with the same signature and return type of `m()`.
Suppose there is an invocation of `m()` in `T` that does not follow the form `J.super.m()`.
With this change `T` will link without error but once the invocation to `m()` is triggered an error is thrown.
In any case, this change might result in unpredictable behaviour or a compilation error (c.f. *JLS 13.5.6*).

**Detection**

1. Client abstract classes implementing two or more interfaces, where at least one of the interfaces has a method with the same signature of the new default method; and the client class has no new method definition with such signature.

<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

<p class="message">
  Behavioural changes are not being reported. For instance, no detection is reported if an interface introduces a new default method and there is already a definition of a method with the same signature in the client type.
</p>

For example, there is a client type `client.C`, and two API interfaces `api.I` and `otherapi.J`. 
The type `client.C` implements both `api.I` and `otherapi.J`. 
Suppose `otherapi.J` defines method `m()` as a default method. 
The API evolves and `api.I` has a new default method `m()` with the same signature as the one provided in `otherapi.J`. 
If `client.C` has no definition of a method `m()` that overrides the previous implementation, then the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+method:///api/I/m()|,
  implements(),
  methodNewDefault(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method No Longer Static
A field goes from `static` to `non-static` becoming an instance field. The field cannot be accessed through its class, instead it should be accessed through an object of the corresponding type. 

**Detection**

1. Client methods invoking a method that is no longer `static`.

<p class="message">
  Static methods cannot be overriden, that is why we do not consider overriding relations.
</p>

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a static method `mA()`. Assume `mC()` invokes `mA()` in a static manner (i.e. `A.mA()`). If the `static` modifier is removed from `mA()`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  fieldAccess(),
  methodNoLongerStatic(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Now Abstract
A method goes from `non-abstract` to `abstract`. Non-abstract client types must provide an implementation. Method invocations pointing to the target method will break.  

**Detection**

1. Client types that must provide an implementation of the method. These types are non-abstract subtypes of the API type owning the method.
2. Client methods invoking a method that is now `abstract` in the direct parent type and no implementation is provided.
2. Client methods overriding a method that is now `abstract ` in a transitive parent type and no implementation is provided.

<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a method `mA()`. Assume `mC()` invokes `mA()`. If `mA()` is declared as `abstract` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  methodNowAbstract(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Now Final
A method goes from `non-final` to `final`, thus the method cannot be overriden. Client code breaks if there is an attempt to override the method.

**Detection**

1. Client methods overriding a method that is now `final` in the direct parent type.
2. Client methods overriding a method that is now `final` in a transitive parent type.

<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a method `mA()`. Assume `mC()` overrides `mA()`. If `mA()` is declared as `final` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodOverride(),
  methodNowFinal(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Now Static
A method goes from `non-static` to `static`. This results in a linkage error, mainly because static methods must be invoked with the JVM instruction `invokestatic`. Client code must be recompiled to get rid of the issue (cf. *JLS 13.4.19*).

**Detection**

1. Client methods invoking a method that is now `static`.
2. Client methods invoking a supertype method that is now `static` through the `super` keyword.
3. Client methods invoking a supertype method that is now `static` without the `super` keyword.
4. Client methods overriding a method that is now `static` in the direct parent type.
5. Client methods overriding a method that is now `static` in a transitive parent type.

<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a method `mA()`. Assume `mC()` invokes `mA()`. If `mA()` is declared as `static` in `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  methodNowStatic(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Now Throws Checked Exception
A method adds a new exception to the throws clause in its declaration.
This change is binary compatible.
However, it triggers a set of compilation errors given that client entities invoking the method need to handle the new exception. 

**Detection**

1. Client methods invoking the modified method without using it within a `try-catch` block that catches the new exception. 

For example, there is a client type `client.C` with a method `mC()`.
There is also an API type `api.A` with a method `mA()` that does not throw any exception.
`mC()` invokes `mA()` without using a `try-catch` block.
If the declaration of `mA()` is changed so it now throws a new checked exception, 
then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+class:///api/A/mA()|,
  methodInvocation(),
  methodNowThrowsCheckedException(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Method Removed
A method is removed from its parent class. 
Client projects are not able to invoke it anymore.

**Detection**

1. Client methods invoking or overriding a method that is removed due to its parent type removal.
2. Client methods invoking or overriding a method that is removed from an API type.
3. Client methods invoking a supertype method through the `super` keyword.
4. Client methods invoking a supertype method without using the `super` keyword.
5. Transitive detections affecting all subtypes are reported with the *Method Removed in Superclass* change. 

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a method `mA()`. 
Assume `mC()` invokes `mA()`. 
If `mA()` is removed from `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  constructorRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Removed In Superclass

A method is removed from a supertype class. Subtypes are not able to invoke it anymore.

**Detection**

1. Client methods invoking or overriding a method that has been inherited from a supertype and whose type has been removed.
2. Client methods invoking or overriding a method that has been inherited from a supertype and that has been removed from the corresponding type.
3. Client methods invoking or overriding a method that has been inherited from a supertype through the `super` keyword.
4. Client methods invoking or overriding a method that has been inherited from a supertype without using the `super` keyword.

<p class="message">
  We consider all direct subtypes of the type that owns the removed method, which do not shadow the target method.
</p>

For example, there is an API type `api.A` that extends from the API type `api.SuperA`. The later defines a method `mSuper()`. There is also a client type `client.C` that extends `api.A`. Type `client.C` has a method definition `m()`. Assume `m()` invokes `mSuper()`. If `mSUper()` is removed from `api.SuperA`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+method:///api/SuperA/mSuper()|,
  methodInvocation(),
  methodRemovedInSuperclass(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Method Return Type Changed
The return type of the method has changed. 

TODO: what king of binary error do we get?
Check conversion cases in assignment, invocation, String, casting, and numeric contexts (cf. Java Language Specification Chapter 5.1). Check the following table:

| Conversion type     | Description| Breakage      |
|---------------------|------------|---------------|
| Identity | Type `T` to type `T` | Never|
| Widening primitive  | Smaller primitive type to wider primitive type| Never |
| Narrowing primitive | Wider primitive type to smaller primitive type| Sometimes (1) |
| Widening reference | Subtype `T` to supertype `ST` | Never |
| Narrowing reference | Supertype `ST` to subtype `T` | Sometimes (2) |
| Boxing | Primitive type `P` to wrapper reference type `R` | Never |
| Unboxing | Wrapper reference type `R` to primitive type `P` | Sometimes (3) 
| Unchecked | Interface type `G` to parameterized type `G<T1,..,Tn>` | Sometimes (4) | 

(1) It will result in a breaking change if no explicit cast is present in the old API version.
(2)
(3) Long, Float
(4) Type erasure 

**Detection** 
 
1. Client methods invoking a method with modified return type.
2. Client methods invoking a modified supertype method through the `super` keyword.
4. Client methods invoking a modified supertype method without using the `super` keyword.
5. Client methods overriding a method with modified return type in the direct parent type.
5. Client methods overriding a method with modified return type in a transitive parent type.

<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not shadow the target method.
</p>
 
For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a method `mA()` with return type `T`. Assume `mC()` invokes `mA()`. If the return type of `mA()` is changed to type `R`, then the following detection is reported:
 
```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  methodReturnTypeChanged(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Class Less Accessible 
The type is less accessible. 
Some client entities are not able to depend on, be annotated with, implement, or inherit from this type anymore (cf. *JLS 13.4.3*). 
The following table provides the less access permited situations in Java (cf. *JLS 13.4.7*). 
We report which of them might break client code, and which exceptions must be considered regarding methods use.

| Source | Target | Detection |
|--------|--------|-----------|
| `public` | `protected` | (Only applicable to inner types.) All entities depending on, or all types implementing or extending the target type except if they are subtypes of the supertype of the target type. Exceptions related to the `public` to `package-private` change are also considered. |
| `public` | `package-private` | All entities depending on, or all types implementing or extending the target type except if they are placed in a package with the same qualified name as the target type. |
| `public` | `private` | All entities depending on, or all types implementing or extending the target type. |
| `protected` | `package-private` | All entities depending on, or all types implementing or extending the target type except if they are placed in a package with the same qualified name as the target type. |
| `protected` | `private` |  All entities depending on, or all types implementing or extending the target type. |
| `package-private` | `private` |  All entities depending on, or all types implementing or extending the target type. |

**Detection**

1. Client entities within type `T` depending on or being annotated with type `S`, where: i) `T` is not a subtype of `S`; ii)`T` is not located in a package with the same qualified name as the parent package of `S`; and iii) `S` goes from `public` to `protected`. 
2. Client types each one represented by `T` implementing or extending type `S`, where: i) `T` is not a subtype of `S`; ii)`T` is not located in a package with the same qualified name as the parent package of `S`; and iii) `S` goes from `public` to `protected`. 
3. Client entities within type `T` depending on or being annotated with type `S`, where: i)`T` is not located in a package with the same qualified name as the parent package of `S`; and ii) `S` goes from `public` to `package-private`. 
4. Client types each one represented by `T` implementing or extending type `S`, where: i)`T` is not located in a package with the same qualified name as the parent package of `S`; and ii) `S` goes from `public` to `package-private`. 
5. Client entities within type `T` depending on or being annotated with type `S`, where: i)`T` is not located in a package with the same qualified name as the parent package of `S`; and ii) `S` goes from `protected` to `package-private`. 
6. Client types each one represented by `T` implementing or extending type `S`, where: i)`T` is not located in a package with the same qualified name as the parent package of `S`; and ii) `S` goes from `protected` to `package-private`. 
7. Client entities within type `T` depending on or being annotated with type `S`, where `S` goes from any visibility to `private`. 
6. Client types each one represented by `T` implementing or extending type `S`, where `S` goes from any visibility to `private`.  

For example, there is a client type `client.C` with a method definition `mC()`.
There is also a public API type `api.A` with a public method `mA()`.
`client.C` extends `api.A`.
Method `mC()` invokes `mA()` through the `super` keyword.
If the visibility of `api.A` is changed from `public` to `package-private`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+class:///api/A|,
  typeDependency(),
  classLessAccessible(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Class No Longer Public
The visibility of a class is reduced from `public` or `protected` to any other access modifier.
If a client member depends on the modified type and the change forbids the client member access to the type, then an `IllegalAccessError` is reported at link time (cf. *JLS 13.4.3*).
A compilation error is also obtained.

**Detection**

1. Client classes extending, implementing, or being annotated with the modified type. These types are reported only if they have no longer access to the modified type.
2. Client members depending on the modified type. These members are reported only if their parent type has no longer access to the modified type.

For example, there is a client type `client.C` with a method definition `m(api.A)`, and a public API type `api.A`.
If the visibility of `api.A` is changed from `public` to `package-private`, then the following detection is reported:

```
detection(
  |java+parameter:///client/C/m(api.A)/param0|,
  |java+class:///api/A|,
  typeDependency(),
  classNoLongerPublic(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Class Now Abstract
A class goes from `non-abstract` to `abstract`. It is not posible to create new objects from the given type.

**Detection**

1. Client methods invoking the constructor of the `abstract` type.
2. Client methods invoking the constructor of the now `abstract` supertype through the `super` keyword (?).
3. Client methods invoking the constructor of the now `abstract` supertype without the `super` keyword (?).

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A`. Assume `m()` creates an object of type `api.A` by invoking its constructor `A()`. If `api.A` is declared as `abstract`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+constructor:///api/A/A()|,
  methodInvocation(),
  classNowAbstract(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Class Now Checked Exception

A class extends from `java.lang.Exception`.
This change is binary compatible.
However, it triggers a set of compilation errors given that methods depending on the modified type need to add it in the throws declaration.

**Detection**

1. Client methods instantiating and throwing the exception (or a suptybe of it) without the corresponding declaration.

For example, `api.E` is an unchecked exception inheriting from `java.lang.RuntimeException`.
There is a client type `client.C` that has a method definition `m()`.
At some point, method `m()` creates and throws `api.E` without adding the exception to the method declaration.
If `api.E` inherits now from `java.lang.Exception`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+class:///api/E|,
  methodInvocation(),
  classNowCheckedException(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Class Now Final
A class goes from `non-final` to `final`, thus the class cannot be extended by other types anymore. 

**Detection**

1. Client types extending an API class that is now `final`.
2. Client methods overriding a method contained in an API class that is now `final`.

<p class="message">
  We consider all transitive client subtypes of the client type that extends the `final` API type.
</p>

For example, there is a client type `client.C` and an API type `api.A`. If `client.C` extends `api.A` and `api.A` is declared as `final`, then the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+class:///api/A|,
  extends(),
  classNowFinal(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Class Removed
API members depending on or annotated with the removed type are affected. 
Types extending or implementing the removed type cannot use it anymore.
 
**Detection**

1. API members depending on or annotated with the removed type.
2. Types extending or implementing the removed type.
3. Members contained in the removed type are also unavailable. These cases are reported with the *Method Removed* and the *Field Removed* changes.
4. Transitive detections affecting all subtypes are reported with the *Method Removed in Superclass* and the *Field Removed in Superclass* changes. 

For example, there is an API type `api.A` and a client type `client.C`. The latter extends `api.A`. If `api.A` is removed, `client.C` cannot include this inheritance in the class declaration, then the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+class:///api/A|,
  extends(),
  classRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

## Class Type Changed
The type of the class changes. 
A class type could be `class`, `interface`, `enum`, or `annotation`.

The following table provides a set of cases where client code might break when changing the type of a class. 
Some of these cases are detected by other API change detections.
We still mention them to have the overall picture of possible situations.
We also report on our assumptions during the bytecode analysis.

| Source | Target | Detection |
|--------|--------|----------|
| `class` | Any | Client classes cannot extend it. |
| `class` | `interface` | The constructor of the class cannot be invoked (cf. *Method Now Abstract* or *Method Removed*) |
| `class` | `enum` | The constructor of the class cannot be invoked (cf. *Constructors Less Accessible*) |
| `class` | `annotation` | Client entities cannot depend on the type.|
| `interface` | Any | Client interfaces cannot extend it. Client classes cannot implement it. |
| `interface` | `annotation ` | Client entities cannot depend on the type. |
| `enum` | Any | Static access of enum fields might be affected (cf. *Field No Longer Static*)|
| `enum` | `annotation` | Client entities cannot depend on the type. | 
| `annotation` | Any | Client entities cannot be tagged with the annotation. |

*Assumptions:*

- A `class` type does not appear in the `implements` relation as implemented type.
- An `interface` type can also be extended by other interfaces.
- In the case of `enum` types we expect no occurrence in the `extends` and `implements` relation (an `enum` can only extend the `java.lang.Enum` class).
- Contained changes related to children elements (i.e. methods and fields) are reported by other detections. 
For instance, if a `class` type is changed to an `interface`, expect detections related to *Class Now Abstract* and *Method Now Abstract* changes.

**Detection**

1. Client classes extending an API type that goes from `class` to any other class type.
2. Client entities depending on an API type that goes from `class` to `annotation`.
3. Client interfaces extending an API type that goes from `interface` to any other class type.
4. Client classes implementing an API type that goes from `interface` to any other class type.
5. Client entities depending on an API type that goes from `interface` to `annotation`.
6. Client entities depending on an API type that goes from `enum` to `annotation`.
7. Client entities annotated with an API type that goes from `annotation` to any other class type.

For example, there is an API interface `api.IA` and a client type `client.C`. 
The latter implements `api.IA`. 
If the type of `api.IA` is changed from `interface` to `class`, `client.C` cannot implement the type anymore. 
Then, the following detection is reported:

```
detection(
  |java+class:///client/C|,
  |java+interface:///api/IA|,
  implements(),
  classTypeChanged(binaryCompatibility=false,sourceCompatibility=false)
)
```
---

## Interface Removed
A type removes an interface from its set of superinterfaces.
Some castings might result in a linkage (or runtime) error.
Subtypes won't be able to access interface fields and default methods anymore.
Moreover, method overridings of the removed interface methods also raise a compilation error (cf. *JLS 13.4.4*).

**Detection**

1. Client methods overriding methods from the removed interface. These methods are owned by a client class that extends or implements the affected type. The latter must be an abstract class.
2. Client methods invoking a default method of the removed interface.
3. Client methods accessing fields of the removed interface.

<p class="message">
  We consider all direct subtypes of the affected type do not redefine target methods.
</p>

For example, there is an abstract API class `api.A`, an API interface `api.IA`, and a client type `client.C`. 
The class `api.A` implements `api.IA` and `client.C` extends `api.A`.
Method `m()` in `client.C` overrides the corresponding method declared in `api.IA`.
If `api.IA` is removed from the set of superinterfaces of `api.A` then `m()` cannot override the corresponding method of the interface anymore.
The following detection is then reported:

```
detection(
	|java+class:///client/C|,
	|java+class:///api/A|,
	extends(),
	interfaceAdded(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Interface Added
A type adds an interface to its set of superinterfaces.
Subtypes of an abstract affected type are obliged to override the interface methods (if any) (cf. *JLS 13.4.4*).

**Detection**

1. Concrete client types extending or implementing the affected type. 
They are included only if the added interface is resolved within the API and has more than one declared method.
  
<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

For example, there is an abstract API class `api.A`, an API interface `api.IA`, and a client type `client.C`. 
The class `client.C` extends `api.A` and `api.IA` declares method `m()`. 
If `api.IA` is added to the set of superinterfaces of `api.A` then `client.C` is forced to override `m()`.
The following detection is then reported:

```
detection(
	|java+class:///client/C|,
	|java+interface:///api/IA|,
	implements(),
	interfaceAdded(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Superclass Removed
A type removes its original superclass.
Castings might result in a compilation error.
Subtypes won't be able to access superclass fields and methods anymore.
Method overridings of the removed superclass methods also raise a compilation error (cf. *JLS 13.4.4*).

**Detection**

1. Client methods overriding methods from the removed superclass. These methods are owned by a client class that extends the affected type. The latter must be an abstract class.
2. Client methods invoking a default method of the removed superclass.
3. Client methods accessing fields of the removed superclass.

<p class="message">
  We consider all direct subtypes of the affected type do not redefine target methods.
</p>

For example, there is an abstract API class `api.A`, an API superclass `api.SA`, and a client type `client.C`. 
The class `api.A` extends `api.SA` and `client.C` extends `api.A`.
Method `m()` in `client.C` overrides the corresponding method declared in `api.SA`.
If `api.IA` is not the superclass of `api.A` anymore, then `m()` cannot override the corresponding method of the superclass.
The following detection is then reported:

```
detection(
	|java+class:///client/C|,
	|java+class:///api/A|,
	extends(),
	superclassAdded(binaryCompatibility=true,sourceCompatibility=false)
)
```

---

## Superclass Added
A type adds a superclass.
Subtypes of an abstract affected type are obliged to override the type methods (if any) (cf. *JLS 13.4.4*).

**Detection**

1. Concrete client types extending or implementing the affected type. 
They are included only if the added superclass is resolved within the API and has more than one declared method.
  
<p class="message">
  We consider all direct subtypes of the type that owns the modified method, which do not define the target method.
</p>

For example, there is an abstract API class `api.A`, an API superclass `api.SA`, and a client type `client.C`. 
The class `client.C` extends `api.A` and `api.SA` declares the abstract method `m()`. 
If `api.SA` is now the superclass of `api.A` then `client.C` is forced to override `m()`.
The following detection is then reported:

```
detection(
	|java+class:///client/C|,
	|java+class:///api/SA|,
	extends(),
	superclassAdded(binaryCompatibility=false,sourceCompatibility=false)
)
```