#[derive(Serialize, Deserialize)]
pub struct EnergyNFTListing {
    token_id: String,
    asking_price: f64,
    terms: String,
}

impl EnergyNFTListing {
    pub fn new(token_id: String, asking_price: f64, terms: String) -> Self {
        EnergyNFTListing {
            token_id,
            asking_price,
            terms,
        }
    }
}
