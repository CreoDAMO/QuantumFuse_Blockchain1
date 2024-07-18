# unicase_serde

[![Build Status](https://travis-ci.org/lawliet89/unicase_serde.svg)](https://travis-ci.org/lawliet89/unicase_serde)
[![Crates.io](https://img.shields.io/crates/v/unicase_serde.svg)](https://crates.io/crates/unicase_serde)
[![Repository](https://img.shields.io/github/tag/lawliet89/unicase_serde.svg)](https://github.com/lawliet89/unicase_serde)
[![Documentation](https://docs.rs/unicase_serde/badge.svg)](https://docs.rs/unicase_serde)

- Documentation:  [stable](https://docs.rs/unicase_serde/) | [master branch](https://lawliet89.github.io/unicase_serde)

serde Serialization and Deserialization for [UniCase](https://crates.io/crates/unicase) crate

Support for serialization and deserialization using
[serde](https://serde.rs/).

## Installation

Add the following to Cargo.toml:

```toml
serde = "1.0"
serde_derive = "1.0"
unicase="2.0"
unicase_serde = "0.1.0"
```

## Usage

You will have to use the serde `with` [field attribute](https://serde.rs/field-attrs.html) to
annotate any `UniCase` or `Ascii` fields with the appropriate module. See examples below.

## Serialization
Serialization for any `UniCase<S>` and `Ascii<S>` where  `S: AsRef<str>` is
implemented. Examples for `S` include `&str`, `Cow<'a, str>`, and `String`.

The same `Serialize` implementation is provided in all the modules.

## Deserialization

You can deserialize strings into `UniCase<S>` and `Ascii<S>` where

- `S: FromStr + AsRef<str>`
- `S: From<&'de str> + AsRef<str> + 'de`

### `S: FromStr + AsRef<str>`
The `Deserialize` implementation is provided in the `unicase_serde::unicase` and
`unicase_serde::ascii` modules.
Conversion is done using the `FromStr::from_str` function.

Typically, you will use the this implementation for any Rust built in type that owns the data
and does not borrow anything.
Example include `String`.

You will know when you need to use the second case
when you get trait bound errors such
"as the trait bound `&'a str: std::convert::From<&str>` is not satisfied".

### `S: From<&'de str> + AsRef<str> + 'de`
The `Deserialize` implementation is provided in the `unicase_serde::unicase::borrowed` and
`unicase_serde::ascii::borrowed` modules.

The second case is meant for usage with Rust built in types that borrow data. Conversion
is done using the `Into::into` function.

If you use the second case with any type that owns data, you will get an error at runtime.

## Example Serialization and Deserialization
```rust
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate unicase;
extern crate unicase_serde;

use std::borrow::Cow;
use unicase::{UniCase, Ascii};

#[derive(Serialize, Deserialize)]
struct TestUniCase<'a> {
    #[serde(with = "unicase_serde::unicase")]
    owned: UniCase<String>,
    #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
    borrowed_str: UniCase<&'a str>,
    #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
    cow_str: UniCase<Cow<'a, str>>,
}

#[derive(Serialize, Deserialize)]
struct TestAscii<'a> {
    #[serde(with = "unicase_serde::ascii")]
    owned: Ascii<String>,
    #[serde(borrow, with = "unicase_serde::ascii::borrowed")]
    borrowed_str: Ascii<&'a str>,
    #[serde(borrow, with = "unicase_serde::ascii::borrowed")]
    cow_str: Ascii<Cow<'a, str>>,
}

# fn main() {
# }
```

## Example with Custom "string" types
This example will demonstrate how you can use a "custom" string type and
still use serialization and deserialization when wrapped inside a `UniCase` or `Ascii`. This
is particularly useful for types like `UniCase<Cow<'a, String>>` or `UniCase<&'a String>`
because `&String` does not implement `From::<&str>`.

As you can see from the example below, you can use the direct `Deserialize` implementation
to deserialize borrowed data. This usually does not work with Rust built in types due to
missing trait implementation. However, because the conversion is done using the
`FromStr::from_str` function, and the function signature indicates that the `&str` passed in
might have an ephemeral lifetime, implementors will have to convert the `&str` into an owned
version. So you are better off using the borrowed deserializer.

```rust
extern crate serde;
#[macro_use]
extern crate serde_derive;
extern crate unicase;
extern crate unicase_serde;

use std::borrow::Cow;
use std::str::FromStr;
use unicase::UniCase;

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
    #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
    test_str: UniCase<CustomStr<'a>>,
    #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
    test_string: UniCase<CustomString<'a>>,
    #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
    test_str_borrowed: UniCase<CustomStr<'a>>,
    #[serde(borrow, with = "unicase_serde::unicase::borrowed")]
    test_string_borrowed: UniCase<CustomString<'a>>,
}
```
