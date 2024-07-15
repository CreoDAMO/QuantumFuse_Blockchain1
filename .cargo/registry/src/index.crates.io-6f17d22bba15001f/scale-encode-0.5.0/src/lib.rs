// Copyright (C) 2023 Parity Technologies (UK) Ltd. (admin@parity.io)
// This file is a part of the scale-encode crate.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#![cfg_attr(not(feature = "std"), no_std)]

/*!
`parity-scale-codec` provides an `Encode` trait which allows types to SCALE encode themselves based on their shape.
This crate builds on this, and allows types to encode themselves based on [`scale_info`] type information. It
exposes two traits:

- An [`EncodeAsType`] trait which when implemented on some type, describes how it can be SCALE encoded
  with the help of a type ID and type registry describing the expected shape of the encoded bytes.
- An [`EncodeAsFields`] trait which when implemented on some type, describes how it can be SCALE encoded
  with the help of an iterator over [`Field`]s and a type registry describing the expected shape of the
  encoded bytes. This is generally only implemented for tuples and structs, since we need a set of fields
  to map to the provided iterator.

Implementations for many built-in types are also provided for each trait, and the [`macro@EncodeAsType`]
macro makes it easy to generate implementations for new structs and enums.

# Motivation

By de-coupling the shape of a type from how it's encoded, we make it much more likely that encoding some type will succeed,
and are no longer reliant on types having a precise layout in order to encode correctly. Some examples of this follow.

```rust
use codec::Encode;
use scale_encode::EncodeAsType;
use scale_info::{PortableRegistry, TypeInfo};

// We are commonly provided type information, but for our examples we construct type info from
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
*/
#![deny(missing_docs)]

extern crate alloc;

mod impls;

pub mod error;

// This is exported for generated derive code to use, to be compatible with std or no-std as needed.
#[doc(hidden)]
pub use alloc::vec::Vec;

pub use error::Error;

// Useful types to help implement EncodeAsType/Fields with:
pub use crate::impls::{Composite, Variant};
pub use scale_info::PortableRegistry;

/// Re-exports of external crates.
pub mod ext {
    #[cfg(feature = "primitive-types")]
    pub use primitive_types;
}

/// This trait signals that some static type can possibly be SCALE encoded given some
/// `type_id` and [`PortableRegistry`] which dictates the expected encoding.
pub trait EncodeAsType {
    /// Given some `type_id`, `types`, a `context` and some output target for the SCALE encoded bytes,
    /// attempt to SCALE encode the current value into the type given by `type_id`.
    fn encode_as_type_to(
        &self,
        type_id: u32,
        types: &PortableRegistry,
        out: &mut Vec<u8>,
    ) -> Result<(), Error>;

    /// This is a helper function which internally calls [`EncodeAsType::encode_as_type_to`]. Prefer to
    /// implement that instead.
    fn encode_as_type(&self, type_id: u32, types: &PortableRegistry) -> Result<Vec<u8>, Error> {
        let mut out = Vec::new();
        self.encode_as_type_to(type_id, types, &mut out)?;
        Ok(out)
    }
}

/// This is similar to [`EncodeAsType`], except that it can be implemented on types that can be encoded
/// to bytes given a list of fields instead of a single type ID. This is generally implemented just for
/// tuple and struct types, and is automatically implemented via the [`macro@EncodeAsType`] macro.
pub trait EncodeAsFields {
    /// Given some fields describing the shape of a type, attempt to encode to that shape.
    fn encode_as_fields_to(
        &self,
        fields: &mut dyn FieldIter<'_>,
        types: &PortableRegistry,
        out: &mut Vec<u8>,
    ) -> Result<(), Error>;

    /// This is a helper function which internally calls [`EncodeAsFields::encode_as_fields_to`]. Prefer to
    /// implement that instead.
    fn encode_as_fields(
        &self,
        fields: &mut dyn FieldIter<'_>,
        types: &PortableRegistry,
    ) -> Result<Vec<u8>, Error> {
        let mut out = Vec::new();
        self.encode_as_fields_to(fields, types, &mut out)?;
        Ok(out)
    }
}

/// A representation of a single field to be encoded via [`EncodeAsFields::encode_as_fields_to`].
#[derive(Debug, Clone, Copy)]
pub struct Field<'a> {
    name: Option<&'a str>,
    id: u32,
}

impl<'a> Field<'a> {
    /// Construct a new field with an ID and optional name.
    pub fn new(id: u32, name: Option<&'a str>) -> Self {
        Field { id, name }
    }
    /// Create a new unnamed field.
    pub fn unnamed(id: u32) -> Self {
        Field { name: None, id }
    }
    /// Create a new named field.
    pub fn named(id: u32, name: &'a str) -> Self {
        Field {
            name: Some(name),
            id,
        }
    }
    /// The field name, if any.
    pub fn name(&self) -> Option<&'a str> {
        self.name
    }
    /// The field ID.
    pub fn id(&self) -> u32 {
        self.id
    }
}

/// An iterator over a set of fields.
pub trait FieldIter<'a>: Iterator<Item = Field<'a>> {}
impl<'a, T> FieldIter<'a> for T where T: Iterator<Item = Field<'a>> {}

/// The `EncodeAsType` derive macro can be used to implement `EncodeAsType`
/// on structs and enums whose fields all implement `EncodeAsType`.
///
/// # Examples
///
/// This can be applied to structs and enums:
///
/// ```rust
/// use scale_encode::EncodeAsType;
///
/// #[derive(EncodeAsType)]
/// struct Foo(String);
///
/// #[derive(EncodeAsType)]
/// struct Bar {
///     a: u64,
///     b: bool
/// }
///
/// #[derive(EncodeAsType)]
/// enum Wibble<T> {
///     A(usize, bool, T),
///     B { value: String },
///     C
/// }
/// ```
///
/// If you aren't directly depending on `scale_encode`, you must tell the macro what the path
/// to it is so that it knows how to generate the relevant impls:
///
/// ```rust
/// # use scale_encode as alt_path;
/// use alt_path::EncodeAsType;
///
/// #[derive(EncodeAsType)]
/// #[encode_as_type(crate_path = "alt_path")]
/// struct Foo<T> {
///    a: u64,
///    b: T
/// }
/// ```
///
/// If you use generics, the macro will assume that each of them also implements `EncodeAsType`.
/// This can be overridden when it's not the case (the compiler will ensure that you can't go wrong here):
///
/// ```rust
/// use scale_encode::EncodeAsType;
///
/// #[derive(EncodeAsType)]
/// #[encode_as_type(trait_bounds = "")]
/// struct Foo<T> {
///    a: u64,
///    b: bool,
///    c: std::marker::PhantomData<T>
/// }
/// ```
///
/// # Attributes
///
/// - `#[encode_as_type(crate_path = "::path::to::scale_encode")]`:
///   By default, the macro expects `scale_encode` to be a top level dependency,
///   available as `::scale_encode`. If this is not the case, you can provide the
///   crate path here.
/// - `#[encode_as_type(trait_bounds = "T: Foo, U::Input: EncodeAsType")]`:
///   By default, for each generate type parameter, the macro will add trait bounds such
///   that these type parameters must implement `EncodeAsType` too. You can override this
///   behaviour and provide your own trait bounds instead using this option.
#[cfg(feature = "derive")]
pub use scale_encode_derive::EncodeAsType;

#[cfg(test)]
mod test {
    use super::*;
    use alloc::boxed::Box;

    // Confirm object safety of EncodeAsFields; we want this.
    // (doesn't really need to run; compile time only.)
    #[test]
    fn is_object_safe() {
        fn _foo(_input: Box<dyn EncodeAsFields>) {}
    }
}
