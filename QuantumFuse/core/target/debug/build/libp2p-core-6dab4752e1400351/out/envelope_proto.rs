/// Envelope encloses a signed payload produced by a peer, along with the public
/// key of the keypair it was signed with so that it can be statelessly validated
/// by the receiver.
///
/// The payload is prefixed with a byte string that determines the type, so it
/// can be deserialized deterministically. Often, this byte string is a
/// multicodec.
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct Envelope {
    /// public_key is the public key of the keypair the enclosed payload was
    /// signed with.
    #[prost(message, optional, tag="1")]
    pub public_key: ::core::option::Option<super::keys_proto::PublicKey>,
    /// payload_type encodes the type of payload, so that it can be deserialized
    /// deterministically.
    #[prost(bytes="vec", tag="2")]
    pub payload_type: ::prost::alloc::vec::Vec<u8>,
    /// payload is the actual payload carried inside this envelope.
    #[prost(bytes="vec", tag="3")]
    pub payload: ::prost::alloc::vec::Vec<u8>,
    /// signature is the signature produced by the private key corresponding to
    /// the enclosed public key, over the payload, prefixing a domain string for
    /// additional security.
    #[prost(bytes="vec", tag="5")]
    pub signature: ::prost::alloc::vec::Vec<u8>,
}
