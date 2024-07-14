/// PeerRecord messages contain information that is useful to share with other peers.
/// Currently, a PeerRecord contains the public listen addresses for a peer, but this
/// is expected to expand to include other information in the future.
///
/// PeerRecords are designed to be serialized to bytes and placed inside of
/// SignedEnvelopes before sharing with other peers.
#[derive(Clone, PartialEq, ::prost::Message)]
pub struct PeerRecord {
    /// peer_id contains a libp2p peer id in its binary representation.
    #[prost(bytes="vec", tag="1")]
    pub peer_id: ::prost::alloc::vec::Vec<u8>,
    /// seq contains a monotonically-increasing sequence counter to order PeerRecords in time.
    #[prost(uint64, tag="2")]
    pub seq: u64,
    /// addresses is a list of public listen addresses for the peer.
    #[prost(message, repeated, tag="3")]
    pub addresses: ::prost::alloc::vec::Vec<peer_record::AddressInfo>,
}
/// Nested message and enum types in `PeerRecord`.
pub mod peer_record {
    /// AddressInfo is a wrapper around a binary multiaddr. It is defined as a
    /// separate message to allow us to add per-address metadata in the future.
    #[derive(Clone, PartialEq, ::prost::Message)]
    pub struct AddressInfo {
        #[prost(bytes="vec", tag="1")]
        pub multiaddr: ::prost::alloc::vec::Vec<u8>,
    }
}
