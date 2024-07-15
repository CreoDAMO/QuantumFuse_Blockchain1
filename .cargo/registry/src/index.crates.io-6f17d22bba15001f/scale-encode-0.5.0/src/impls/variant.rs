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

use crate::{
    error::{Error, ErrorKind, Kind},
    EncodeAsFields, EncodeAsType, Field,
};
use alloc::{string::ToString, vec::Vec};
use codec::Encode;
use scale_info::{PortableRegistry, TypeDef};

/// This type represents named or unnamed composite values, and can be used
/// to help generate `EncodeAsType` impls. It's primarily used by the exported
/// macros to do just that.
///
/// ```rust
/// use scale_encode::{ Error, EncodeAsType, Composite, Variant, PortableRegistry };
///
/// enum MyType {
///    SomeField(bool),
///    OtherField { foo: u64, bar: String }
/// }
///
/// impl EncodeAsType for MyType {
///     fn encode_as_type_to(&self, type_id: u32, types: &PortableRegistry, out: &mut Vec<u8>) -> Result<(), Error> {
///         match self {
///             MyType::SomeField(b) => Variant {
///                 name: "SomeField",
///                 fields: Composite([
///                     (None, b as &dyn EncodeAsType),
///                 ].into_iter())
///             }.encode_as_type_to(type_id, types, out),
///             MyType::OtherField { foo, bar } => Variant {
///                 name: "OtherField",
///                 fields: Composite([
///                     (Some("foo"), foo as &dyn EncodeAsType),
///                     (Some("bar"), bar as &dyn EncodeAsType)
///                 ].into_iter())
///             }.encode_as_type_to(type_id, types, out)
///         }
///     }
/// }
/// ```
pub struct Variant<'a, Vals> {
    /// The name of the variant we'll try to encode into.
    pub name: &'a str,
    /// The fields of the variant that we wish to encode.
    pub fields: super::composite::Composite<Vals>,
}

impl<'a, Vals> EncodeAsType for Variant<'a, Vals>
where
    Vals: ExactSizeIterator<Item = (Option<&'a str>, &'a dyn EncodeAsType)> + Clone,
{
    fn encode_as_type_to(
        &self,
        type_id: u32,
        types: &PortableRegistry,
        out: &mut Vec<u8>,
    ) -> Result<(), Error> {
        let type_id = super::find_single_entry_with_same_repr(type_id, types);
        let ty = types
            .resolve(type_id)
            .ok_or_else(|| Error::new(ErrorKind::TypeNotFound(type_id)))?;

        match &ty.type_def {
            TypeDef::Variant(var) => {
                let vars = &var.variants;
                let Some(v) = vars.iter().find(|v| v.name == self.name) else {
                    return Err(Error::new(ErrorKind::CannotFindVariant { name: self.name.to_string(), expected: type_id }));
                };
                v.index.encode_to(out);
                let mut fields = v
                    .fields
                    .iter()
                    .map(|f| Field::new(f.ty.id, f.name.as_deref()));
                self.fields.encode_as_fields_to(&mut fields, types, out)
            }
            _ => Err(Error::new(ErrorKind::WrongShape {
                actual: Kind::Str,
                expected: type_id,
            })),
        }
    }
}
