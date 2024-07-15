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
    EncodeAsType,
};
use alloc::vec::Vec;
use scale_info::TypeDef;

impl EncodeAsType for scale_bits::Bits {
    fn encode_as_type_to(
        &self,
        type_id: u32,
        types: &scale_info::PortableRegistry,
        out: &mut Vec<u8>,
    ) -> Result<(), crate::Error> {
        let type_id = super::find_single_entry_with_same_repr(type_id, types);
        let ty = types
            .resolve(type_id)
            .ok_or_else(|| Error::new(ErrorKind::TypeNotFound(type_id)))?;

        if let TypeDef::BitSequence(ty) = &ty.type_def {
            let Ok(format) = scale_bits::Format::from_metadata(ty, types) else {
                return Err(wrong_shape(type_id))
            };

            scale_bits::encode_using_format_to(self.iter(), format, out);
            Ok(())
        } else {
            Err(wrong_shape(type_id))
        }
    }
}

fn wrong_shape(type_id: u32) -> Error {
    Error::new(ErrorKind::WrongShape {
        actual: Kind::BitSequence,
        expected: type_id,
    })
}
