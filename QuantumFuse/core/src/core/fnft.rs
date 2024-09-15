// src/core/fnft.rs
pub struct FNFT {
    pub id: String,
    pub original_nft_id: String,
    pub fractions: HashMap<String, Fraction>,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Fraction {
    pub owner: String,
    pub percentage: f64,  // Ownership percentage
}

pub struct FNFTContract {
    pub fnfts: HashMap<String, FNFT>,
    pub next_fnft_id: u64,
}

impl FNFTContract {
    pub fn new() -> Self {
        FNFTContract {
            fnfts: HashMap::new(),
            next_fnft_id: 0,
        }
    }

    pub fn create_fnft(&mut self, original_nft_id: &str, fractions: HashMap<String, Fraction>) -> String {
        let fnft_id = self.next_fnft_id.to_string();
        let fnft = FNFT {
            id: fnft_id.clone(),
            original_nft_id: original_nft_id.to_string(),
            fractions,
        };
        self.fnfts.insert(fnft_id.clone(), fnft);
        self.next_fnft_id += 1;
        fnft_id
    }

    pub fn trade_fraction(&mut self, fnft_id: &str, fraction_owner: &str, new_owner: &str) -> Result<(), String> {
        if let Some(fnft) = self.fnfts.get_mut(fnft_id) {
            if let Some(fraction) = fnft.fractions.get_mut(fraction_owner) {
                fraction.owner = new_owner.to_string();
                return Ok(());
            }
        }
        Err("Fraction not found".to_string())
    }

    pub fn get_fnft_details(&self, fnft_id: &str) -> Option<&FNFT> {
        self.fnfts.get(fnft_id)
    }
}
