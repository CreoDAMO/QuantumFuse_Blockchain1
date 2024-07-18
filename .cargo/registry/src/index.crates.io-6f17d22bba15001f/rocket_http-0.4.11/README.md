# Rocket

[![Build Status](https://dev.azure.com/SergioBenitez/Rocket/_apis/build/status/SergioBenitez.Rocket?branchName=v0.4)](https://dev.azure.com/SergioBenitez/Rocket/_build/latest?definitionId=3&branchName=v0.4)
[![Rocket Homepage](https://img.shields.io/badge/web-rocket.rs-red.svg?style=flat&label=https&colorB=d33847)](https://rocket.rs)
[![Current Crates.io Version](https://img.shields.io/crates/v/rocket.svg)](https://crates.io/crates/rocket)
[![Matrix: #rocket:mozilla.org](https://img.shields.io/badge/style-%23rocket:mozilla.org-blue.svg?style=flat&label=[m])](https://chat.mozilla.org/#/room/#rocket:mozilla.org)
[![IRC: #rocket on chat.freenode.net](https://img.shields.io/badge/style-%23rocket-blue.svg?style=flat&label=freenode)](https://kiwiirc.com/client/chat.freenode.net/#rocket)

Rocket is a web framework for Rust (nightly) with a focus on ease-of-use,
expressibility, and speed. Here's an example of a complete Rocket application:

```rust
#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

#[get("/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}

fn main() {
    rocket::ignite().mount("/hello", routes![hello]).launch();
}
```

Visiting `localhost:8000/hello/John/58`, for example, will trigger the `hello`
route resulting in the string `Hello, 58 year old named John!` being sent to the
browser. If an `<age>` string was passed in that can't be parsed as a `u8`, the
route won't get called, resulting in a 404 error.

## Documentation

Rocket is extensively documented:

  * [Overview]: A brief look at what makes Rocket special.
  * [Quickstart]: How to get started as quickly as possible.
  * [Getting Started]: How to start your first Rocket project.
  * [Guide]: A detailed guide and reference to Rocket.
  * [API Documentation]: The "rustdocs".

[Quickstart]: https://rocket.rs/v0.4/guide/quickstart
[Getting Started]: https://rocket.rs/v0.4/guide/getting-started
[Overview]: https://rocket.rs/v0.4/overview
[Guide]: https://rocket.rs/v0.4/guide
[API Documentation]: https://api.rocket.rs/v0.4/rocket

The official community support channels are [`#rocket:mozilla.org`] on Matrix
and the bridged [`#rocket`] IRC channel on Freenode at `chat.freenode.net`. We
recommend joining us on [Matrix via Riot]. If your prefer IRC, you can join via
the [Kiwi IRC client] or a client of your own.

[`#rocket:mozilla.org`]: https://chat.mozilla.org/#/room/#rocket:mozilla.org
[`#rocket`]: https://kiwiirc.com/client/chat.freenode.net/#rocket
[Matrix via Riot]: https://chat.mozilla.org/#/room/#rocket:mozilla.org
[Kiwi IRC Client]: https://kiwiirc.com/client/chat.freenode.net/#rocket

## Building

### Nightly

Rocket requires a nightly version of Rust as it makes heavy use of syntax
extensions. This means that the first two unwieldly lines in the introductory
example above are required.

### Core, Codegen, and Contrib

All of the Rocket libraries are managed by Cargo. As a result, compiling them is
simple.

  * Core: `cd lib && cargo build`
  * Codegen: `cd codegen && cargo build`
  * Contrib: `cd contrib && cargo build --all-features`

### Examples

Rocket ships with an extensive number of examples in the `examples/` directory
which can be compiled and run with Cargo. For instance, the following sequence
of commands builds and runs the `Hello, world!` example:

```
cd examples/hello_world
cargo run
```

You should see `Hello, world!` by visiting `http://localhost:8000`.

## Testing

To test Rocket, simply run `./scripts/test.sh` from the root of the source tree.
This will build and test the `core`, `codegen`, and `contrib` libraries as well
as all of the examples. The `test.sh` script accepts no flags or either the
`--release` flag to test in release mode or the `--contrib` flag to test all
`contrib` modules individually. This script gets run by CI.

To test a crate individually, run `cargo test --all-features` in the
corresponding crate directory.

### Core

Testing for the core library is done inline in the corresponding module. For
example, the tests for routing can be found at the bottom of the
`lib/src/router/mod.rs` file.

### Codegen

Code generation tests can be found in `codegen/tests`. We use the
[compiletest](https://crates.io/crates/compiletest_rs) library, which was
extracted from `rustc`, for testing. See the [compiler test
documentation](https://github.com/rust-lang/rust/blob/master/src/test/COMPILER_TESTS.md)
for information on how to write compiler tests.

## Documentation

You can build the Rocket API documentation locally by running
`./scripts/mk-docs.sh`. The resulting documentation is what gets uploaded to
[api.rocket.rs](https://api.rocket.rs/v0.4/).

## Contributing

Contributions are absolutely, positively welcome and encouraged! Contributions
come in many forms. You could:

  1. Submit a feature request or bug report as an [issue](https://github.com/SergioBenitez/Rocket/issues).
  2. Ask for improved documentation as an [issue](https://github.com/SergioBenitez/Rocket/issues).
  3. Comment on [issues that require
     feedback](https://github.com/SergioBenitez/Rocket/issues?q=is%3Aissue+is%3Aopen+label%3A%22feedback+wanted%22).
  4. Contribute code via [pull requests](https://github.com/SergioBenitez/Rocket/pulls).

We aim to keep Rocket's code quality at the highest level. This means that any
code you contribute must be:

  * **Commented:** Public items _must_ be commented.
  * **Documented:** Exposed items _must_ have rustdoc comments with
    examples, if applicable.
  * **Styled:** Your code should be `rustfmt`'d when possible.
  * **Simple:** Your code should accomplish its task as simply and
     idiomatically as possible.
  * **Tested:** You must add (and pass) convincing tests for any functionality you add.
  * **Focused:** Your code should do what it's supposed to do and nothing more.

All pull requests are code reviewed and tested by the CI. Note that unless you
explicitly state otherwise, any contribution intentionally submitted for
inclusion in Rocket by you shall be dual licensed under the MIT License and
Apache License, Version 2.0, without any additional terms or conditions.

## License

Rocket is licensed under either of the following, at your option:

 * Apache License, Version 2.0, ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
 * MIT License ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

The Rocket website source is licensed under [separate terms](site#license).
