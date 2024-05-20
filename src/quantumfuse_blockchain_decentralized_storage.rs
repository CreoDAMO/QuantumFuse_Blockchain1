extern crate ipfs_api;

use ipfs_api::IpfsClient;
use std::io::Cursor;

impl QuantumFuseBlockchain {
    fn store_data_on_ipfs(&self, data: &str) -> Result<String, String> {
        let client = IpfsClient::default();
        let data = Cursor::new(data);
        match client.add(data).await {
            Ok(res) => Ok(res.hash),
            Err(e) => Err(e.to_string()),
        }
    }
}
