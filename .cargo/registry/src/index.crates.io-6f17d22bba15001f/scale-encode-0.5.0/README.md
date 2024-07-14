# scale-encode

`parity-scale-codec` provides an `Encode` trait which allows types to SCALE encode themselves based on their shape.
This crate builds on this, and allows types to encode themselves based on `scale_info` type information. It
exposes two traits:

- An `EncodeAsType` trait which when implemented on some type, describes how it can be SCALE encoded
  with the help of a type ID and type registry describing the expected shape of the encoded bytes.
- An `EncodeAsFields` trait which when implemented on some type, describes how it can be SCALE encoded
  with the help of a slice of `PortableField`'s or `PortableFieldId`'s and type registry describing the
  expected shape of the encoded bytes. This is generally only implemented for tuples and structs, since we
  need a set of fields to map to the provided slices.

Implementations for many built-in types are also provided for each trait, and the `macro@EncodeAsType`
macro makes it easy to generate implementations for new structs and enums.

# Motivation

By de-coupling the shape of a type from how it's encoded, we make it much more likely that encoding some type will succeed,
and are no longer reliant on types having a precise layout in order to encode correctly. Some examples of this follow.

```rust
use codec::Encode;
use scale_encode::EncodeAsType;
use scale_info::{PortableRegistry, TypeInfo};

// We are comonly provided type information, but for our examples we construct type info from
// any type that implements `TypeInfo`.
fn get_type_info<T: TypeInfo + 'static>() -> (u32, PortableRegistry) {
    let m = scale_info::MetaType::new::<T>();
    let mut types = scale_info::Registry::new();
    let ty = types.register_type(&m);
    let portable_registry: PortableRegistry = types.into();
    (ty.id(), portable_registry)
}

// Encode the left value via EncodeAsType into the shape of the right value.
// Encode the right value statically.
// Assert that both outputs are identical.
fn assert_encodes_to<A, B>(a: A, b: B)
where
    A: EncodeAsType,
    B: TypeInfo + Encode + 'static,
{
    let (type_id, types) = get_type_info::<B>();
    let a_bytes = a.encode_as_type(type_id, &types).unwrap();
    let b_bytes = b.encode();
    assert_eq!(a_bytes, b_bytes);
}

// Start simple; a u8 can EncodeAsType into a u64 and vice versa. Numbers will all
// try to convert into the desired output size, failing if this isn't possible:
assert_encodes_to(123u8, 123u64);
assert_encodes_to(123u64, 123u8);

// Compact encoding is also handled "under the hood" by EncodeAsType, so no "compact"
// annotations are needed on values.
assert_encodes_to(123u64, codec::Compact(123u64));

// Enum variants are lined up by variant name, so no explicit "index" annotation are
// needed either; EncodeAsType will take care of it.
#[derive(EncodeAsType)]
enum Foo {
    Something(u64),
}
#[derive(Encode, TypeInfo)]
enum FooTarget {
    #[codec(index = 10)]
    Something(u128),
}
assert_encodes_to(Foo::Something(123), FooTarget::Something(123));

// EncodeAstype will just ignore named fields that aren't needed:
#[derive(EncodeAsType)]
struct Bar {
    a: bool,
    b: String,
}
#[derive(Encode, TypeInfo)]
struct BarTarget {
    a: bool,
}
assert_encodes_to(
    Bar { a: true, b: "hello".to_string() },
    BarTarget { a: true },
);

// EncodeAsType will attempt to remove any newtype wrappers and such on either
// side, so that they can be omitted without any issue.
#[derive(EncodeAsType, Encode, TypeInfo)]
struct Wrapper {
    value: u64
}
assert_encodes_to(
    (Wrapper { value: 123 },),
    123u64
);
assert_encodes_to(
    123u64,
    (Wrapper { value: 123 },)
);

// Things like arrays and sequences are generally interchangeable despite the
// encoding format being slightly different:
assert_encodes_to([1u8,2,3,4,5], vec![1u64,2,3,4,5]);
assert_encodes_to(vec![1u64,2,3,4,5], [1u8,2,3,4,5]);

// BTreeMap, as a slightly special case, can encode to the same shape as either
// a sequence or a struct, depending on what's asked for:
use std::collections::BTreeMap;
#[derive(TypeInfo, Encode)]
struct MapOutput {
    a: u64,
    b: u64
}
assert_encodes_to(
    BTreeMap::from_iter([("a", 1u64), ("b", 2u64)]),
    vec![1u64,2]
);
assert_encodes_to(
    BTreeMap::from_iter([("a", 1u64), ("b", 2u64), ("c", 3u64)]),
    MapOutput { a: 1, b: 2 }
);
```