// src/core/tokenized_incentive_system.rs
pub struct IncentiveSystem {
    tokens: HashMap<String, SustainabilityToken>,
}

impl IncentiveSystem {
    pub fn new() -> Self {
        IncentiveSystem {
            tokens: HashMap::new(),
        }
    }

    pub fn reward(&mut self, owner: String, amount: f64) {
        let token_id = format!("token_{}", self.tokens.len() + 1);
        let token = SustainabilityToken::new(token_id.clone(), owner.clone(), amount);
        self.tokens.insert(token_id, token);
    }

    pub fn get_token(&self, token_id: &str) -> Option<&SustainabilityToken> {
        self.tokens.get(token_id)
    }
}
