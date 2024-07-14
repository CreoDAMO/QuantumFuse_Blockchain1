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

use crate::{error::Error, EncodeAsType};
use alloc::vec::Vec;
use primitive_types::{H128, H160, H256, H384, H512, H768};

macro_rules! impl_encode {
    ($($ty:ty),*) => {$(
        impl EncodeAsType for $ty {
            fn encode_as_type_to(&self, type_id: u32, types: &scale_info::PortableRegistry, out: &mut Vec<u8>) -> Result<(), Error> {
                let type_id = super::find_single_entry_with_same_repr(type_id, types);
                self.0.encode_as_type_to(type_id, types, out)
            }
        }
    )*}
}
impl_encode!(H128, H160, H256, H384, H512, H768);
