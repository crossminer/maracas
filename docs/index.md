# Maracas

## Detections

### Field Now Final

**Detection**

```
detection(
  |java+method:///client/C/m()|,
  |java+field:///api/A/f|,
  fieldAccess(),
  fieldRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

### Field Removed
A field is removed from its parent class. Client projects are not able to access it anymore.

**Detection**

1. Client methods accessing a field that is removed due to its parent type removal.
2. Client methods accessing a field that is removed from an API type.
3. Client methods accessing a supertype field through the `super` keyword.
4. Client methods accessing a supertype field without using the `super` keyword.
5. Transitive detections affecting all subtypes are reported with the *Field Removed in Superclass* change. 

{% include note.html content="`javac` inlines constant values, thus this type of field access is lost." %}

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

### Field Removed In Superclass
A field is removed from a supertype class. Subtypes are not able to access it anymore.

**Detection**

1. Client methods accessing a field that has been inherited from a supertype and whose type has been removed.
2. Client methods accessing a field that has been inherited from a supertype and that has been removed from the corresponding type.
3. Client methods accessing a field that has been inherited from a supertype through the `super` keyword.
4. Client methods accessing a field that has been inherited from a supertype without using the `super` keyword.

{% include note.html content="We consider all direct subtypes of the type that owns the removed field, which do not shadow the target field." %}

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

### Constructor Removed
If the constructor or the parent class is removed, this issue is reported. Client projects are not able to create objects with the corresponding method.

**Detection** 

1. Client methods invoking a constructor that is removed due to its parent type removal.
2. Client methods invoking a constructor that is removed from an API type.
3. Client constructors invoking an supertype constructor through the `super` keyword. 

For instance, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a constructor `A(int)`. Assume `m()` invokes `A(int)` to create an object of type `api.A`. If `A(int)` is removed from `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/m()|,
  |java+constructor:///api/A/A(int)|,
  methodInvocation(),
  constructorRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

### Method Abstract Added In Superclass
An abstract method is added to a superclass and no implementation is provided in (maybe part of) the API hierarchy. This change is reported only if subtypes are abstract. Client types affected by this issue extend one of the subtypes of the superclass where the abstract method was added.

---

### Method Removed
A method is removed from its parent class. Client projects are not able to invoke it anymore.

**Detection**

1. Client methods invoking or overriding a method that is removed due to its parent type removal.
2. Client methods invoking or overriding a method that is removed from an API type.
3. Client methods invoking or overriding a supertype method through the `super` keyword.
4. Client methods invoking or overriding a supertype method without using the `super` keyword.
5. Transitive detections affecting all subtypes are reported with the *Method Removed in Superclass* change. 

For example, there is a client type `client.C` with a method definition `mC()`, and an API type `api.A` with a method `mA()`. Assume `mC()` invokes `mA()`. If `mA()` is removed from `api.A`, then the following detection is reported:

```
detection(
  |java+method:///client/C/mC()|,
  |java+method:///api/A/mA()|,
  methodInvocation(),
  constructorRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

---

### Method Removed In Superclass

A method is removed from a supertype class. Subtypes are not able to invoke it anymore.

**Detection**

1. Client methods invoking or overriding a method that has been inherited from a supertype and whose type has been removed.
2. Client methods invoking or overriding a method that has been inherited from a supertype and that has been removed from the corresponding type.
3. Client methods invoking or overriding a method that has been inherited from a supertype through the `super` keyword.
4. Client methods invoking or overriding a method that has been inherited from a supertype without using the `super` keyword.

{% include note.html content="We consider all direct subtypes of the type that owns the removed method, which do not shadow the target method." %}

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

### Class Less Accessible 
Types depending on, implementing, or inheriting from the affected type might not be able to access it anymore. This depends on the new visbility of the type and its relation to depending types. 

| Source            | Target            | Breakage   
|-------------------|-------------------|--------------|
| `public`          | `protected`       | Sometimes (1)|
| `public`          | `package-private` | Sometimes (2)|
| `public`          | `private`         | Always       |
| `protected`       | `package-private` | Sometimes (2)|
| `protected`       | `private`         | Always       |
| `package-private` | `private`         | Always       |

1. The type can be accessed by other types that inherit from the parent class, or from types defined in the same package.
2. The type can be accessed by types defined in the same in the same package.

---

### Class Removed
API members depending on or annotated with the removed type are affected. Types extending or implementing the removed type cannot use it anymore.
 
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

### Class Type Changed

#### Case #1: `class` changes to other type
Other classes cannot extend from it anymore. We check all tuples in the `extends` relation where the type appears as supertype.

#### Case #2: `interface` changes to other type
Other interfaces cannot extend from it anymore. We check all tuples in the `extends` relation where the type appears as supertype and the subtype is an `interface`. In addtion, classes cannot implement it. We check cases where a `class` type `implements` the target type. 

#### Case #3: `enum` changes to other type
An `enum` type cannot be extended or implemented. As mentioned in the *Assumptions* section, we consider all type dependencies and contained changes are reported by other detections.

#### Case #4: `annotation` changes to other type
No entity can have an annotation pointing to the affected type. This is checked in the `annotations` relation.

**Assumptions:**
- All type dependencies are prone to experience a breakage, thus we report all detections related to the `typeDependency` relation.
- A `class` type does not appear in the `implements` relation as implemented type.
- An `interface` type can also be extended by other interfaces.
- In the case of `enum` types we expect no occurrence in the `extends` and `implements` relation (an `enum` can only extend the java.lang.Enum class).
- Contained changes related to children elements (i.e. methods and fields) are reported by other detections. For instance, if a `class` type is changed to an `interface`, expect detections related to *class now abstract* and *method now abstract* changes.

---