# Maracas

## Detections

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
