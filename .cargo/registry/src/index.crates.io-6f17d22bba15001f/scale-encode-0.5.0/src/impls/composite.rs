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
    error::{Error, ErrorKind, Kind, Location},
    EncodeAsFields, EncodeAsType, Field, FieldIter,
};
use alloc::collections::BTreeMap;
use alloc::{string::ToString, vec::Vec};
use scale_info::{PortableRegistry, TypeDef};

/// This type represents named or unnamed composite values, and can be used
/// to help generate `EncodeAsType` impls. It's primarily used by the exported
/// macros to do just that.
///
/// ```rust
/// use scale_encode::{ Error, EncodeAsType, Composite, PortableRegistry };
///
/// struct MyType {
///    foo: bool,
///    bar: u64,
///    wibble: String
/// }
///
/// impl EncodeAsType for MyType {
///     fn encode_as_type_to(&self, type_id: u32, types: &PortableRegistry, out: &mut Vec<u8>) -> Result<(), Error> {
///         Composite([
///             (Some("foo"), &self.foo as &dyn EncodeAsType),
///             (Some("bar"), &self.bar as &dyn EncodeAsType),
///             (Some("wibble"), &self.wibble as &dyn EncodeAsType)
///         ].into_iter()).encode_as_type_to(type_id, types, out)
///     }
/// }
/// ```
pub struct Composite<Vals>(pub Vals);

impl<'a, Vals> EncodeAsType for Composite<Vals>
where
    Vals: ExactSizeIterator<Item = (Option<&'a str>, &'a dyn EncodeAsType)> + Clone,
{
    fn encode_as_type_to(
        &self,
        type_id: u32,
        types: &PortableRegistry,
        out: &mut Vec<u8>,
    ) -> Result<(), Error> {
        let mut vals_iter = self.0.clone();
        let vals_iter_len = vals_iter.len();

        // Skip through any single field composites/tuples without names. If there
        // are names, we may want to line up input field(s) on them.
        let type_id = skip_through_single_unnamed_fields(type_id, types);

        let ty = types
            .resolve(type_id)
            .ok_or_else(|| Error::new(ErrorKind::TypeNotFound(type_id)))?;

        match &ty.type_def {
            // If we see a tuple type, it'll have more than one field else it'd have been skipped above.
            TypeDef::Tuple(tuple) => {
                // If there is exactly one val, it won't line up with the tuple then, so
                // try encoding one level in instead.
                if vals_iter_len == 1 {
                    return vals_iter
                        .next()
                        .unwrap()
                        .1
                        .encode_as_type_to(type_id, types, out);
                }

                let mut fields = tuple.fields.iter().map(|f| Field::unnamed(f.id));
                self.encode_as_fields_to(&mut fields, types, out)
            }
            // If we see a composite type, it has either named fields or !=1 unnamed fields.
            TypeDef::Composite(composite) => {
                // If vals are named, we may need to line them up with some named composite.
                // If they aren't named, we only care about lining up based on matching lengths.
                let is_named_vals = vals_iter.clone().any(|(name, _)| name.is_some());

                // If there is exactly one val that isn't named, then we know it won't line
                // up with this composite then, so try encoding one level in.
                if !is_named_vals && vals_iter_len == 1 {
                    return vals_iter
                        .next()
                        .unwrap()
                        .1
                        .encode_as_type_to(type_id, types, out);
                }

                let mut fields = composite
                    .fields
                    .iter()
                    .map(|f| Field::new(f.ty.id, f.name.as_deref()));
                self.encode_as_fields_to(&mut fields, types, out)
            }
            // We may have skipped through to some primitive or other type.
            _ => {
                // Rather than immediately giving up, we should at least see whether
                // we can skip one level in to our value and encode that.
                if vals_iter_len == 1 {
                    return vals_iter
                        .next()
                        .unwrap()
                        .1
                        .encode_as_type_to(type_id, types, out);
                }

                // If we get here, then it means the value we were given had more than
                // one field, and the type we were given was ultimately some one-field thing
                // that contained a non composite/tuple type, so it would never work out.
                Err(Error::new(ErrorKind::WrongShape {
                    actual: Kind::Tuple,
                    expected: type_id,
                }))
            }
        }
    }
}

impl<'a, Vals> EncodeAsFields for Composite<Vals>
where
    Vals: ExactSizeIterator<Item = (Option<&'a str>, &'a dyn EncodeAsType)> + Clone,
{
    fn encode_as_fields_to(
        &self,
        fields: &mut dyn FieldIter<'_>,
        types: &PortableRegistry,
        out: &mut Vec<u8>,
    ) -> Result<(), Error> {
        let vals_iter = self.0.clone();

        // Most of the time there aren't too many fields, so avoid allocation in most cases:
        let fields = smallvec::SmallVec::<[_; 16]>::from_iter(fields);

        // Both the target and source type have to have named fields for us to use
        // names to line them up.
        let is_named = {
            let is_target_named = fields.iter().any(|f| f.name().is_some());
            let is_source_named = vals_iter.clone().any(|(name, _)| name.is_some());
            is_target_named && is_source_named
        };

        if is_named {
            // target + source fields are named, so hash source values by name and
            // then encode to the target type by matching the names. If fields are
            // named, we don't even mind if the number of fields doesn't line up;
            // we just ignore any fields we provided that aren't needed.
            let source_fields_by_name: BTreeMap<&str, &dyn EncodeAsType> = vals_iter
                .map(|(name, val)| (name.unwrap_or(""), val))
                .collect();

            for field in fields {
                // Find the field in our source type:
                let name = field.name().unwrap_or("");
                let Some(value) = source_fields_by_name.get(name) else {
                    return Err(Error::new(ErrorKind::CannotFindField { name: name.to_string() }))
                };

                // Encode the value to the output:
                value
                    .encode_as_type_to(field.id(), types, out)
                    .map_err(|e| e.at_field(name.to_string()))?;
            }

            Ok(())
        } else {
            let fields_len = fields.len();

            // target fields aren't named, so encode by order only. We need the field length
            // to line up for this to work.
            if fields_len != vals_iter.len() {
                return Err(Error::new(ErrorKind::WrongLength {
                    actual_len: vals_iter.len(),
                    expected_len: fields_len,
                }));
            }

            for (idx, (field, (name, val))) in fields.iter().zip(vals_iter).enumerate() {
                val.encode_as_type_to(field.id(), types, out).map_err(|e| {
                    let loc = if let Some(name) = name {
                        Location::field(name.to_string())
                    } else {
                        Location::idx(idx)
                    };
                    e.at(loc)
                })?;
            }
            Ok(())
        }
    }
}

// Single unnamed fields carry no useful information and can be skipped through.
// Single named fields may still be useful to line up with named composites.
fn skip_through_single_unnamed_fields(type_id: u32, types: &PortableRegistry) -> u32 {
    let Some(ty) = types.resolve(type_id) else {
        return type_id
    };
    match &ty.type_def {
        TypeDef::Tuple(tuple) if tuple.fields.len() == 1 => {
            skip_through_single_unnamed_fields(tuple.fields[0].id, types)
        }
        TypeDef::Composite(composite)
            if composite.fields.len() == 1 && composite.fields[0].name.is_none() =>
        {
            skip_through_single_unnamed_fields(composite.fields[0].ty.id, types)
        }
        _ => type_id,
    }
}
