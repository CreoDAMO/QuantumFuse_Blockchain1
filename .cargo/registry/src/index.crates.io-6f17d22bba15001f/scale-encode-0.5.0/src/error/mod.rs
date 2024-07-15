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

//! An error that is emitted whenever some encoding fails.
mod context;

use alloc::{borrow::Cow, boxed::Box, string::String};
use core::fmt::Display;

pub use context::{Context, Location};

/// An error produced while attempting to encode some type.
#[derive(Debug)]
pub struct Error {
    context: Context,
    kind: ErrorKind,
}

#[cfg(feature = "std")]
impl std::error::Error for Error {}

impl Error {
    /// Construct a new error given an error kind.
    pub fn new(kind: ErrorKind) -> Error {
        Error {
            context: Context::new(),
            kind,
        }
    }
    /// Construct a new, custom error.
    pub fn custom(error: impl CustomError) -> Error {
        Error::new(ErrorKind::Custom(Box::new(error)))
    }
    /// Construct a custom error from a static string.
    pub fn custom_str(error: &'static str) -> Error {
        #[derive(derive_more::Display, Debug)]
        pub struct StrError(pub &'static str);
        #[cfg(feature = "std")]
        impl std::error::Error for StrError {}

        Error::new(ErrorKind::Custom(Box::new(StrError(error))))
    }
    /// Construct a custom error from an owned string.
    pub fn custom_string(error: String) -> Error {
        #[derive(derive_more::Display, Debug)]
        pub struct StringError(String);
        #[cfg(feature = "std")]
        impl std::error::Error for StringError {}

        Error::new(ErrorKind::Custom(Box::new(StringError(error))))
    }
    /// Retrieve more information about what went wrong.
    pub fn kind(&self) -> &ErrorKind {
        &self.kind
    }
    /// Retrieve details about where the error occurred.
    pub fn context(&self) -> &Context {
        &self.context
    }
    /// Give some context to the error.
    pub fn at(mut self, loc: Location) -> Self {
        self.context.push(loc);
        Error {
            context: self.context,
            kind: self.kind,
        }
    }
    /// Note which sequence index the error occurred in.
    pub fn at_idx(mut self, idx: usize) -> Self {
        self.context.push(Location::idx(idx));
        Error {
            context: self.context,
            kind: self.kind,
        }
    }
    /// Note which field the error occurred in.
    pub fn at_field(mut self, field: impl Into<Cow<'static, str>>) -> Self {
        self.context.push(Location::field(field));
        Error {
            context: self.context,
            kind: self.kind,
        }
    }
    /// Note which variant the error occurred in.
    pub fn at_variant(mut self, variant: impl Into<Cow<'static, str>>) -> Self {
        self.context.push(Location::variant(variant));
        Error {
            context: self.context,
            kind: self.kind,
        }
    }
}

impl Display for Error {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        let path = self.context.path();
        let kind = &self.kind;
        write!(f, "Error at {path}: {kind}")
    }
}

/// The underlying nature of the error.
#[derive(Debug, derive_more::From, derive_more::Display)]
pub enum ErrorKind {
    /// Cannot find a given type.
    #[display(fmt = "Cannot find type with ID {_0}")]
    TypeNotFound(u32),
    /// Cannot encode the actual type given into the target type ID.
    #[display(fmt = "Cannot encode {actual:?} into type with ID {expected}")]
    WrongShape {
        /// The actual kind we have to encode
        actual: Kind,
        /// ID of the expected type.
        expected: u32,
    },
    /// The types line up, but the expected length of the target type is different from the length of the input value.
    #[display(
        fmt = "Cannot encode to type; expected length {expected_len} but got length {actual_len}"
    )]
    WrongLength {
        /// Length we have
        actual_len: usize,
        /// Length expected for type.
        expected_len: usize,
    },
    /// We cannot encode the number given into the target type; it's out of range.
    #[display(fmt = "Number {value} is out of range for target type {expected}")]
    NumberOutOfRange {
        /// A string represenatation of the numeric value that was out of range.
        value: String,
        /// Id of the expected numeric type that we tried to encode it to.
        expected: u32,
    },
    /// Cannot find a variant with a matching name on the target type.
    #[display(fmt = "Variant {name} does not exist on type with ID {expected}")]
    CannotFindVariant {
        /// Variant name we can't find in the expected type.
        name: String,
        /// ID of the expected type.
        expected: u32,
    },
    /// Cannot find a field on our source type that's needed for the target type.
    #[display(fmt = "Field {name} does not exist in our source struct")]
    CannotFindField {
        /// Name of the field which was not provided.
        name: String,
    },
    /// A custom error.
    #[from]
    #[display(fmt = "Custom error: {_0}")]
    Custom(Box<dyn CustomError>),
}

/// Anything implementing this trait can be used in [`ErrorKind::Custom`].
#[cfg(feature = "std")]
pub trait CustomError: std::error::Error + Send + Sync + 'static {}
#[cfg(feature = "std")]
impl<T: std::error::Error + Send + Sync + 'static> CustomError for T {}

/// Anything implementing this trait can be used in [`ErrorKind::Custom`].
#[cfg(not(feature = "std"))]
pub trait CustomError: core::fmt::Debug + core::fmt::Display + Send + Sync + 'static {}
#[cfg(not(feature = "std"))]
impl<T: core::fmt::Debug + core::fmt::Display + Send + Sync + 'static> CustomError for T {}

/// The kind of type that we're trying to encode.
#[allow(missing_docs)]
#[derive(Copy, Clone, PartialEq, Eq, Debug)]
pub enum Kind {
    Struct,
    Tuple,
    Variant,
    Array,
    BitSequence,
    Bool,
    Char,
    Str,
    Number,
}

#[cfg(test)]
mod test {
    use super::*;

    #[derive(Debug, derive_more::Display)]
    enum MyError {
        Foo,
    }

    #[cfg(feature = "std")]
    impl std::error::Error for MyError {}

    #[test]
    fn custom_error() {
        // Just a compile-time check that we can ergonomically provide an arbitrary custom error:
        Error::custom(MyError::Foo);
    }
}
