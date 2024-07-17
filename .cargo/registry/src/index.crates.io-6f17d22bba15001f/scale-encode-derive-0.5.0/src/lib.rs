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

use darling::FromAttributes;
use proc_macro2::TokenStream as TokenStream2;
use quote::{format_ident, quote};
use syn::{parse_macro_input, punctuated::Punctuated, DeriveInput};

// The default attribute name for attrs
const ATTR_NAME: &str = "encode_as_type";

// Macro docs in main crate; don't add any docs here.
#[proc_macro_derive(EncodeAsType, attributes(encode_as_type, codec))]
pub fn derive_macro(input: proc_macro::TokenStream) -> proc_macro::TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    // parse top level attrs.
    let attrs = match TopLevelAttrs::parse(&input.attrs) {
        Ok(attrs) => attrs,
        Err(e) => return e.write_errors().into(),
    };

    derive_with_attrs(attrs, input).into()
}

fn derive_with_attrs(attrs: TopLevelAttrs, input: DeriveInput) -> TokenStream2 {
    // what type is the derive macro declared on?
    match &input.data {
        syn::Data::Enum(details) => generate_enum_impl(attrs, &input, details),
        syn::Data::Struct(details) => generate_struct_impl(attrs, &input, details),
        syn::Data::Union(_) => syn::Error::new(
            input.ident.span(),
            "Unions are not supported by the EncodeAsType macro",
        )
        .into_compile_error(),
    }
}

fn generate_enum_impl(
    attrs: TopLevelAttrs,
    input: &DeriveInput,
    details: &syn::DataEnum,
) -> TokenStream2 {
    let path_to_scale_encode = &attrs.crate_path;
    let path_to_type: syn::Path = input.ident.clone().into();
    let (impl_generics, ty_generics, where_clause) = handle_generics(&attrs, &input.generics);

    // For each variant we want to spit out a match arm.
    let match_arms = details.variants.iter().map(|variant| {
        let variant_name = &variant.ident;
        let variant_name_str = variant_name.to_string();

        let (matcher, composite) =
            fields_to_matcher_and_composite(path_to_scale_encode, &variant.fields);
        quote!(
            Self::#variant_name #matcher => {
                #path_to_scale_encode::Variant { name: #variant_name_str, fields: #composite }
                    .encode_as_type_to(
                        __encode_as_type_type_id,
                        __encode_as_type_types,
                        __encode_as_type_out
                    )
            }
        )
    });

    quote!(
        impl #impl_generics #path_to_scale_encode::EncodeAsType for #path_to_type #ty_generics #where_clause {
            #[allow(unused_variables)]
            fn encode_as_type_to(
                &self,
                // long variable names to prevent conflict with struct field names:
                __encode_as_type_type_id: u32,
                __encode_as_type_types: &#path_to_scale_encode::PortableRegistry,
                __encode_as_type_out: &mut #path_to_scale_encode::Vec<u8>
            ) -> Result<(), #path_to_scale_encode::Error> {
                match self {
                    #( #match_arms, )*
                    // This will never be encountered, but in case the enum has no variants
                    // the compiler will still want something to be spat out here:
                    _ => unreachable!()
                }
            }
        }
    )
}

fn generate_struct_impl(
    attrs: TopLevelAttrs,
    input: &DeriveInput,
    details: &syn::DataStruct,
) -> TokenStream2 {
    let path_to_scale_encode = &attrs.crate_path;
    let path_to_type: syn::Path = input.ident.clone().into();
    let (impl_generics, ty_generics, where_clause) = handle_generics(&attrs, &input.generics);

    let (matcher, composite) =
        fields_to_matcher_and_composite(path_to_scale_encode, &details.fields);

    quote!(
        impl #impl_generics #path_to_scale_encode::EncodeAsType for #path_to_type #ty_generics #where_clause {
            #[allow(unused_variables)]
            fn encode_as_type_to(
                &self,
                // long variable names to prevent conflict with struct field names:
                __encode_as_type_type_id: u32,
                __encode_as_type_types: &#path_to_scale_encode::PortableRegistry,
                __encode_as_type_out: &mut #path_to_scale_encode::Vec<u8>
            ) -> Result<(), #path_to_scale_encode::Error> {
                let #path_to_type #matcher = self;
                #composite.encode_as_type_to(
                    __encode_as_type_type_id,
                    __encode_as_type_types,
                    __encode_as_type_out
                )
            }
        }
        impl #impl_generics #path_to_scale_encode::EncodeAsFields for #path_to_type #ty_generics #where_clause {
            #[allow(unused_variables)]
            fn encode_as_fields_to(
                &self,
                // long variable names to prevent conflict with struct field names:
                __encode_as_type_fields: &mut dyn #path_to_scale_encode::FieldIter<'_>,
                __encode_as_type_types: &#path_to_scale_encode::PortableRegistry,
                __encode_as_type_out: &mut #path_to_scale_encode::Vec<u8>
            ) -> Result<(), #path_to_scale_encode::Error> {
                let #path_to_type #matcher = self;
                #composite.encode_as_fields_to(
                    __encode_as_type_fields,
                    __encode_as_type_types,
                    __encode_as_type_out
                )
            }
        }
    )
}

fn handle_generics<'a>(
    attrs: &TopLevelAttrs,
    generics: &'a syn::Generics,
) -> (
    syn::ImplGenerics<'a>,
    syn::TypeGenerics<'a>,
    syn::WhereClause,
) {
    let path_to_crate = &attrs.crate_path;
    let (impl_generics, ty_generics, where_clause) = generics.split_for_impl();

    let mut where_clause = where_clause.cloned().unwrap_or(syn::parse_quote!(where));

    if let Some(where_predicates) = &attrs.trait_bounds {
        // if custom trait bounds are given, append those to the where clause.
        where_clause.predicates.extend(where_predicates.clone());
    } else {
        // else, append our default EncodeAsType bounds to the where clause.
        for param in generics.type_params() {
            let ty = &param.ident;
            where_clause
                .predicates
                .push(syn::parse_quote!(#ty: #path_to_crate::EncodeAsType))
        }
    }

    (impl_generics, ty_generics, where_clause)
}

fn fields_to_matcher_and_composite(
    path_to_scale_encode: &syn::Path,
    fields: &syn::Fields,
) -> (TokenStream2, TokenStream2) {
    match fields {
        syn::Fields::Named(fields) => {
            let match_body = fields.named.iter().map(|f| {
                let field_name = &f.ident;
                quote!(#field_name)
            });
            let tuple_body = fields.named
                .iter()
                .filter(|f| !should_skip(&f.attrs))
                .map(|f| {
                    let field_name_str = f.ident.as_ref().unwrap().to_string();
                    let field_name = &f.ident;
                    quote!((Some(#field_name_str), #field_name as &dyn #path_to_scale_encode::EncodeAsType))
                });

            (
                quote!({#( #match_body ),*}),
                quote!(#path_to_scale_encode::Composite([#( #tuple_body ),*].into_iter())),
            )
        }
        syn::Fields::Unnamed(fields) => {
            let field_idents = fields
                .unnamed
                .iter()
                .enumerate()
                .map(|(idx, f)| (format_ident!("_{idx}"), f));

            let match_body = field_idents.clone().map(|(i, _)| quote!(#i));
            let tuple_body = field_idents
                .filter(|(_, f)| !should_skip(&f.attrs))
                .map(|(i, _)| quote!((None as Option<&'static str>, #i as &dyn #path_to_scale_encode::EncodeAsType)));

            (
                quote!((#( #match_body ),*)),
                quote!(#path_to_scale_encode::Composite([#( #tuple_body ),*].into_iter())),
            )
        }
        syn::Fields::Unit => (
            quote!(),
            quote!(#path_to_scale_encode::Composite(([] as [(Option<&'static str>, &dyn #path_to_scale_encode::EncodeAsType);0]).into_iter())),
        ),
    }
}

struct TopLevelAttrs {
    // path to the scale_encode crate, in case it's not a top level dependency.
    crate_path: syn::Path,
    // allow custom trait bounds to be used instead of the defaults.
    trait_bounds: Option<Punctuated<syn::WherePredicate, syn::Token!(,)>>,
}

impl TopLevelAttrs {
    fn parse(attrs: &[syn::Attribute]) -> darling::Result<Self> {
        use darling::FromMeta;

        #[derive(FromMeta)]
        struct TopLevelAttrsInner {
            #[darling(default)]
            crate_path: Option<syn::Path>,
            #[darling(default)]
            trait_bounds: Option<Punctuated<syn::WherePredicate, syn::Token!(,)>>,
        }

        let mut res = TopLevelAttrs {
            crate_path: syn::parse_quote!(::scale_encode),
            trait_bounds: None,
        };

        // look at each top level attr. parse any for encode_as_type.
        for attr in attrs {
            if !attr.path.is_ident(ATTR_NAME) {
                continue;
            }
            let meta = attr.parse_meta()?;
            let parsed_attrs = TopLevelAttrsInner::from_meta(&meta)?;

            res.trait_bounds = parsed_attrs.trait_bounds;
            if let Some(crate_path) = parsed_attrs.crate_path {
                res.crate_path = crate_path;
            }
        }

        Ok(res)
    }
}

// Checks if the attributes contain `skip`.
//
// NOTE: Since we only care about `skip` at the moment, we just expose this helper,
// but if we add more attrs we can expose `FieldAttrs` properly:
fn should_skip(attrs: &[syn::Attribute]) -> bool {
    #[derive(FromAttributes, Default)]
    #[darling(attributes(encode_as_type, codec))]
    struct FieldAttrs {
        #[darling(default)]
        skip: bool,
    }

    FieldAttrs::from_attributes(attrs).unwrap_or_default().skip
}
