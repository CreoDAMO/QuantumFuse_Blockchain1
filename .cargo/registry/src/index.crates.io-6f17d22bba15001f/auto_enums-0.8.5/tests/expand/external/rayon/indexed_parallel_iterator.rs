// SPDX-License-Identifier: Apache-2.0 OR MIT

extern crate rayon_crate as rayon;

use auto_enums::enum_derive;

#[enum_derive(rayon::IndexedParallelIterator)]
enum Enum<A, B> {
    A(A),
    B(B),
}

fn main() {}
