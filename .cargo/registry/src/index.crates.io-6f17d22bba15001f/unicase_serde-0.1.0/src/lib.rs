
//! [![Build Status](https://travis-ci.org/lawliet89/unicase_serde.svg)](https://travis-ci.org/lawliet89/unicase_serde)
//! [![Crates.io](https://img.shields.io/crates/v/unicase_serde.svg)](https://crates.io/crates/unicase_serde)
//! [![Repository](https://img.shields.io/github/tag/lawliet89/unicase_serde.svg)](https://github.com/lawliet89/unicase_serde)
//! [![Documentation](https://docs.rs/unicase_serde/badge.svg)](https://docs.rs/unicase_serde)
//!
//! - Documentation:  [stable](https://docs.rs/unicase_serde/) | [master branch](https://lawliet89.github.io/unicase_serde)
//!
//! serde Serialization and Deserialization for [UniCase](https://crates.io/crates/unicase) crate
//!
//! Support for serialization and deserialization using
//! [serde](https://serde.rs/).
//!
//! ## Installation
//!
//! Add the following to Cargo.toml:
//!
//! ```toml
//! serde = "1.0"
//! serde_derive = "1.0"
//! unicase="2.0"
//! unicase_serde = "0.1.0"
//! ```
//!
//! ## Usage
//!
//! You will have to use the serde `with` [field attribute](https://serde.rs/field-attrs.html) to
//! annotate any `UniCase` or `Ascii` fields with the appropriate module. See examples below.
//!
//! ## Serialization
//! Serialization for any `UniCase<S>` and `Ascii<S>` where  `S: AsRef<str>` is
//! implemented. Examples for `S` include `&str`, `Cow<'a, str>`, and `String`.
//!
//! The same `Serialize` implementation is provided in all the modules.
//!
//! ## Deserialization
//!
//! You can deserialize strings into `UniCase<S>` and `Ascii<S>` where
//!
//! - `S: FromStr + AsRef<str>`
//! - `S: From<&'de str> + AsRef<str> + 'de`
//!
//! ### `S: FromStr + AsRef<str>`
//! The `Deserialize` implementation is provided in the `unicase_serde::unicase` and
//! `unicase_serde::ascii` modules.
//! Conversion is done using the `FromStr::from_str` function.
//!
//! Typically, you will use the this implementation for any Rust built in type that owns the data
//! and does not borrow anything.
//! Example include `String`.
//!
//! You will know when you need to use the second case
//! when you get trait bound errors such
//! "as the trait bound `&'a str: std::convert::From<&str>` is not satisfied".
//!
//! ### `S: From<&'de str> + AsRef<str> + 'de`
//! The `Deserialize` implementation is provided in the `unicase_serde::unicase::borrowed` and
//! `unicase_serde::ascii::borrowed` modules.
//!
//! The second case is meant for usage with Rust built in types that borrow data. Conversion
//! is done using the `Into::into` function.
//!
//! If you use the second case with any type that owns data, you will get an error at runtime.
//!
//! ## Example Serialization and Deserialization
//! ```rust
//! extern crate serde;
//! #[macro_use]
//! extern crate serde_derive;
//! extern crate unicase;
//! extern crate unicase_serde;
//!
//! use std::borrow::Cow;
//! use unicase::{UniCase, Ascii};
//!
//! #[derive(Serialize, Deserialize)]
//! struct TestUniCase<'a> {
//!     #[serde(with = "unicase_serde::unicase")]
//!     owned: UniCase<String>,
//!     #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
//!     borrowed_str: UniCase<&'a str>,
//!     #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
//!     cow_str: UniCase<Cow<'a, str>>,
//! }
//!
//! #[derive(Serialize, Deserialize)]
//! struct TestAscii<'a> {
//!     #[serde(with = "unicase_serde::ascii")]
//!     owned: Ascii<String>,
//!     #[serde(borrow, with = "unicase_serde::ascii::borrowed")]
//!     borrowed_str: Ascii<&'a str>,
//!     #[serde(borrow, with = "unicase_serde::ascii::borrowed")]
//!     cow_str: Ascii<Cow<'a, str>>,
//! }
//!
//! # fn main() {
//! # }
//! ```
//!
//! ## Example with Custom "string" types
//! This example will demonstrate how you can use a "custom" string type and
//! still use serialization and deserialization when wrapped inside a `UniCase` or `Ascii`. This
//! is particularly useful for types like `UniCase<Cow<'a, String>>` or `UniCase<&'a String>`
//! because `&String` does not implement `From::<&str>`.
//!
//! As you can see from the example below, you can use the direct `Deserialize` implementation
//! to deserialize borrowed data. This usually does not work with Rust built in types due to
//! missing trait implementation. However, because the conversion is done using the
//! `FromStr::from_str` function, and the function signature indicates that the `&str` passed in
//! might have an ephemeral lifetime, implementors will have to convert the `&str` into an owned
//! version. So you are better off using the borrowed deserializer.
//!
//! ```rust
//! extern crate serde;
//! #[macro_use]
//! extern crate serde_derive;
//! extern crate unicase;
//! extern crate unicase_serde;
//!
//! use std::borrow::Cow;
//! use std::str::FromStr;
//! use unicase::UniCase;
//!
//! #[derive(Eq, PartialEq, Debug)]
//! struct CustomStr<'a>(Cow<'a, str>);
//!
//! impl<'a> AsRef<str> for CustomStr<'a> {
//!     fn as_ref(&self) -> &str {
//!         self.0.as_ref()
//!     }
//! }
//!
//! impl<'a> FromStr for CustomStr<'a> {
//!     type Err = ();
//!     fn from_str(s: &str) -> Result<Self, Self::Err> {
//!         Ok(CustomStr(Cow::from(s.to_string())))
//!     }
//! }
//!
//! impl<'a> From<&'a str> for CustomStr<'a> {
//!     fn from(s: &'a str) -> Self {
//!         CustomStr(Cow::from(s))
//!     }
//! }
//!
//! #[derive(Eq, PartialEq, Debug)]
//! struct CustomString<'a>(Cow<'a, String>);
//!
//! impl<'a> AsRef<str> for CustomString<'a> {
//!     fn as_ref(&self) -> &str {
//!         self.0.as_ref()
//!     }
//! }
//!
//! impl<'a> FromStr for CustomString<'a> {
//!     type Err = ();
//!     fn from_str(s: &str) -> Result<Self, Self::Err> {
//!         Ok(CustomString(Cow::Owned(s.to_string())))
//!     }
//! }
//!
//! impl<'a> From<&'a str> for CustomString<'a> {
//!     fn from(s: &'a str) -> Self {
//!         CustomString(Cow::Owned(s.to_string()))
//!     }
//! }
//!
//! #[derive(Serialize, Deserialize, Eq, PartialEq, Debug)]
//! struct TestCustomStruct<'a> {
//!     #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
//!     test_str: UniCase<CustomStr<'a>>,
//!     #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
//!     test_string: UniCase<CustomString<'a>>,
//!     #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
//!     test_str_borrowed: UniCase<CustomStr<'a>>,
//!     #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
//!     test_string_borrowed: UniCase<CustomString<'a>>,
//! }
//!
//! # fn main() {
//! # }
//! ```
extern crate serde as serdelib;
extern crate unicase as unicase_lib;

#[cfg(test)]
#[macro_use]
extern crate serde_derive;
#[cfg(test)]
extern crate serde_test;

pub mod unicase {
    //! Serialization and Deserialization Implementation for `UniCase` that owns data
    //!
    //! See crate level documentation for details.
    use std::fmt;
    use std::marker::PhantomData;
    use std::str::FromStr;

    use unicase_lib::UniCase;
    use serdelib::{Serializer, Deserializer};
    use serdelib::de;

    /// Straightforward Serialization for UniCase
    pub fn serialize<S, Ser>(value: &UniCase<S>, serializer: Ser) -> Result<Ser::Ok, Ser::Error>
    where
        S: AsRef<str>,
        Ser: Serializer,
    {
        serializer.serialize_str(value.as_ref())
    }

    /// Deserialization for `UniCase<S>` where `S: FromStr + AsRef<str>`
    pub fn deserialize<'de, S, D>(deserializer: D) -> Result<UniCase<S>, D::Error>
    where
        S: FromStr + AsRef<str>,
        D: Deserializer<'de>,
    {
        struct UniCaseVisitor<S>(PhantomData<S>);

        impl<'de, S: FromStr + AsRef<str>> de::Visitor<'de> for UniCaseVisitor<S> {
            type Value = UniCase<S>;

            fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                formatter.write_str("a string")
            }

            fn visit_str<E>(self, s: &str) -> Result<Self::Value, E>
            where
                E: de::Error,
            {
                FromStr::from_str(s).map_err(|_| E::custom("FromStr conversion failed"))
            }
        }

        deserializer.deserialize_str(UniCaseVisitor(PhantomData))
    }

    pub mod borrowed {
        //! Serialization and Deserialization Implementation for `UniCase` that borrow data.
        //!
        //! See crate level documentation for details.
        use super::*;
        pub use super::serialize;

        /// Borrowed Deserializer for `UniCase`.
        ///
        /// Typically, you will use this for any types that borrow data. Example include `&str`.
        /// If you use this with any type that owns data, you will get an error at runtime.
        pub fn deserialize<'de, S, D>(deserializer: D) -> Result<UniCase<S>, D::Error>
        where
            S: From<&'de str> + AsRef<str> + 'de,
            D: Deserializer<'de>,
        {
            struct UniCaseVisitor<S>(PhantomData<S>);

            impl<'de, S: From<&'de str> + AsRef<str>> de::Visitor<'de> for UniCaseVisitor<S> {
                type Value = UniCase<S>;

                fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                    formatter.write_str("a string")
                }

                fn visit_borrowed_str<E>(self, s: &'de str) -> Result<Self::Value, E>
                where
                    E: de::Error,
                {
                    Ok(UniCase::unicode(s.into()))
                }
            }

            deserializer.deserialize_str(UniCaseVisitor(PhantomData))
        }
    }
}

pub mod ascii {
    //! Serialization and Deserialization Implementation for `Ascii` that owns data
    //!
    //! See crate level documentation for details.
    use std::fmt;
    use std::marker::PhantomData;
    use std::str::FromStr;

    use unicase_lib::Ascii;
    use serdelib::{Serializer, Deserializer};
    use serdelib::de;

    /// Straightforward Serialization for UniCase
    pub fn serialize<S, Ser>(value: &Ascii<S>, serializer: Ser) -> Result<Ser::Ok, Ser::Error>
    where
        S: AsRef<str>,
        Ser: Serializer,
    {
        serializer.serialize_str(value.as_ref())
    }

    /// Deserialization for `UniCase<S>` where `S: FromStr + AsRef<str>`
    pub fn deserialize<'de, S, D>(deserializer: D) -> Result<Ascii<S>, D::Error>
    where
        S: FromStr + AsRef<str>,
        D: Deserializer<'de>,
    {
        struct AsciiVisitor<S>(PhantomData<S>);

        impl<'de, S: FromStr + AsRef<str>> de::Visitor<'de> for AsciiVisitor<S> {
            type Value = Ascii<S>;

            fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                formatter.write_str("a string")
            }

            fn visit_str<E>(self, s: &str) -> Result<Self::Value, E>
            where
                E: de::Error,
            {
                FromStr::from_str(s).map_err(|_| E::custom("FromStr conversion failed"))
            }
        }

        deserializer.deserialize_str(AsciiVisitor(PhantomData))
    }

    pub mod borrowed {
        //! Serialization and Deserialization Implementation for `Ascii` that borrows data
        //!
        //! See crate level documentation for details.
        use super::*;
        pub use super::serialize;

        /// Borrowed Deserializer for `Ascii`.
        ///
        /// Typically, you will use this for any types that borrow data. Example include `&str`.
        /// If you use this with any type that owns data, you will get an error at runtime.
        pub fn deserialize<'de, S, D>(deserializer: D) -> Result<Ascii<S>, D::Error>
        where
            S: From<&'de str> + AsRef<str> + 'de,
            D: Deserializer<'de>,
        {
            struct AsciiVisitor<S>(PhantomData<S>);

            impl<'de, S: From<&'de str> + AsRef<str>> de::Visitor<'de> for AsciiVisitor<S> {
                type Value = Ascii<S>;

                fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
                    formatter.write_str("a string")
                }

                fn visit_borrowed_str<E>(self, s: &'de str) -> Result<Self::Value, E>
                where
                    E: de::Error,
                {
                    Ok(Ascii::new(s.into()))
                }
            }

            deserializer.deserialize_str(AsciiVisitor(PhantomData))
        }
    }
}

#[cfg(test)]
mod tests {
    use std::borrow::Cow;

    use serde_test::{Token, assert_tokens};
    use unicase_lib::{UniCase, Ascii};

    #[derive(Eq, PartialEq, Debug, Serialize, Deserialize)]
    struct TestUniCase<'a> {
        #[serde(with = "::unicase")]
        owned: UniCase<String>,
        #[serde(borrow, with = "::unicase::borrowed")]
        borrowed_str: UniCase<&'a str>,
        #[serde(borrow, with = "::unicase::borrowed")]
        cow_str: UniCase<Cow<'a, str>>,
    }

    #[derive(Eq, PartialEq, Debug, Serialize, Deserialize)]
    struct TestAscii<'a> {
        #[serde(with = "::ascii")]
        owned: Ascii<String>,
        #[serde(borrow, with = "::ascii::borrowed")]
        borrowed_str: Ascii<&'a str>,
        #[serde(borrow, with = "::ascii::borrowed")]
        cow_str: Ascii<Cow<'a, str>>,
    }

    #[test]
    fn test_unicase_serde() {
        let test = TestUniCase {
            owned: UniCase::unicode("owned string".to_string()),
            borrowed_str: UniCase::unicode("borrowed str"),
            cow_str: UniCase::unicode(Cow::from("Cow str")),
        };

        assert_tokens(
            &test,
            &[
                Token::Struct {
                    name: "TestUniCase",
                    len: 3,
                },
                Token::Str("owned"),
                Token::String("owned string"),
                Token::Str("borrowed_str"),
                Token::BorrowedStr("borrowed str"),
                Token::Str("cow_str"),
                Token::BorrowedStr("Cow str"),
                Token::StructEnd,
            ],
        );
    }

    #[test]
    fn test_ascii_serde() {
        let test = TestAscii {
            owned: Ascii::new("owned string".to_string()),
            borrowed_str: Ascii::new("borrowed str"),
            cow_str: Ascii::new(Cow::from("Cow str")),
        };

        assert_tokens(
            &test,
            &[
                Token::Struct {
                    name: "TestAscii",
                    len: 3,
                },
                Token::Str("owned"),
                Token::String("owned string"),
                Token::Str("borrowed_str"),
                Token::BorrowedStr("borrowed str"),
                Token::Str("cow_str"),
                Token::BorrowedStr("Cow str"),
                Token::StructEnd,
            ],
        );
    }

    // The following code tests that custom structs as inputs to UniCase<S> can compile
    use std::str::FromStr;

    #[derive(Eq, PartialEq, Debug)]
    struct CustomStr<'a>(Cow<'a, str>);
    impl<'a> AsRef<str> for CustomStr<'a> {
        fn as_ref(&self) -> &str {
            self.0.as_ref()
        }
    }

    impl<'a> FromStr for CustomStr<'a> {
        type Err = ();
        fn from_str(s: &str) -> Result<Self, Self::Err> {
            Ok(CustomStr(Cow::from(s.to_string())))
        }
    }

    impl<'a> From<&'a str> for CustomStr<'a> {
        fn from(s: &'a str) -> Self {
            CustomStr(Cow::from(s))
        }
    }

    #[derive(Eq, PartialEq, Debug)]
    struct CustomString<'a>(Cow<'a, String>);
    impl<'a> AsRef<str> for CustomString<'a> {
        fn as_ref(&self) -> &str {
            self.0.as_ref()
        }
    }

    impl<'a> FromStr for CustomString<'a> {
        type Err = ();
        fn from_str(s: &str) -> Result<Self, Self::Err> {
            Ok(CustomString(Cow::Owned(s.to_string())))
        }
    }

    impl<'a> From<&'a str> for CustomString<'a> {
        fn from(s: &'a str) -> Self {
            CustomString(Cow::Owned(s.to_string()))
        }
    }

    #[derive(Serialize, Deserialize, Eq, PartialEq, Debug)]
    struct TestCustomStruct<'a> {
        #[serde(borrow, with = "::unicase::borrowed")]
        test_str: UniCase<CustomStr<'a>>,
        #[serde(borrow, with = "::unicase::borrowed")]
        test_string: UniCase<CustomString<'a>>,
        #[serde(borrow, with = "::unicase::borrowed")]
        test_str_borrowed: UniCase<CustomStr<'a>>,
        #[serde(borrow, with = "::unicase::borrowed")]
        test_string_borrowed: UniCase<CustomString<'a>>,
    }
}
