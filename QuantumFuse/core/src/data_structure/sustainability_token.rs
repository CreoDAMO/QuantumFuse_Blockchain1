pub struct SustainabilityToken {
    token_id: String,
    owner: String,
    amount: f64,
}

impl SustainabilityToken {
    pub fn new(token_id: String, owner: String, amount: f64) -> Self {
        SustainabilityToken {
            token_id,
            owner,
            amount,
        }
    }
}
