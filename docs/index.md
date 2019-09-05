# Maracas

## Detections

### Field Removed
This issue is reported if a field is removed from its parent class. Client projects are not able to access them anymore.

**Detection**

1. Client methods accessing a field that is removed due to its parent type removal.
2. Client methods accessing a field that is removed from an API type.
3. Client methods accessing a supertype field through the `super` keyword.
4. Client methods accessing a supertype field without using the `super` keyword.
5. Transitive detections affecting all subtypes are reported with the *Field Removed in Superclass* change. 

For example, there is a client type `client.C` with a method definition `m()`, and an API type `api.A` with a field `f`. Assume `m()` accesses `f`. If `f` is removed from `api.A`, then the following detection is reported:

```
detection(
	|java+method:///client/C/m()|,
	|java+field:///api/A/f|,
	fieldAccess(),
	fieldRemoved(binaryCompatibility=false,sourceCompatibility=false)
)
```

{% include note.html content="`javac` inlines constant values, thus this type of field access is lost." %}

---

### Field Removed In Superclass
Subtypes won't be able to access the removed field anymore. To identified affected client members we consider the following:

1. Get all subtypes of the API type labelled with this change. We will consider all direct subtypes that do noit shadow the target field.
2. Create symbolic references to the field for each subtype (which includes a symbolic reference to each subtype).
3. Check clients that have a symbolic reference to the target field from any of the abovementioned subtypes or the affected class itself.

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