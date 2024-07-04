extern crate serde;
extern crate serde_json;
extern crate sha2;

use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::HashMap;

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SmartContract {
    pub id: String,
    pub code: String,
    pub owner: String,
    pub state: HashMap<String, String>,
}

impl SmartContract {
    pub fn new(id: &str, code: &str, owner: &str) -> Self {
        SmartContract {
            id: id.to_string(),
            code: code.to_string(),
            owner: owner.to_string(),
            state: HashMap::new(),
        }
    }

    pub fn execute(&mut self, input: &str) -> String {
        // Execute contract logic and update state
        self.state.insert("last_input".to_string(), input.to_string());
        "Executed with input".to_string()
    }

    pub fn update_state(&mut self, key: &str, value: &str) {
        self.state.insert(key.to_string(), value.to_string());
    }

    pub fn get_state(&self, key: &str) -> Option<&String> {
        self.state.get(key)
    }

    pub fn calculate_hash(&self) -> String {
        let data = format!("{}{}{}", self.id, self.owner, serde_json::to_string(&self.state).unwrap());
        let mut hasher = Sha256::new();
        hasher.update(data.as_bytes());
        hex::encode(hasher.finalize())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_smart_contract() {
        let mut contract = SmartContract::new("1", "dummy_code", "Alice");

        assert_eq!(contract.execute("test_input"), "Executed with input".to_string());
        assert_eq!(contract.get_state("last_input"), Some(&"test_input".to_string()));

        contract.update_state("energy_reward", "150");
        assert_eq!(contract.get_state("energy_reward"), Some(&"150".to_string()));

        let hash = contract.calculate_hash();
        assert!(!hash.is_empty());
    }
}
