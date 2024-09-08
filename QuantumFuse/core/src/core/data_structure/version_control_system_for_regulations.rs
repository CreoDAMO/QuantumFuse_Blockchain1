use orx_split_vec::SplitVec;
use std::collections::HashMap;

pub struct Compliance {
    rules: HashMap<String, RuleSet>,
    versions: HashMap<String, SplitVec<RegulatoryUpdate>>,  // Using SplitVec instead of Vec
}

impl Compliance {
    pub fn new() -> Self {
        Compliance {
            rules: HashMap::new(),
            versions: HashMap::new(),
        }
    }

    pub fn update_rules(&mut self, region: String, update: RegulatoryUpdate) {
        if let Some(ruleset) = self.rules.get_mut(&region) {
            ruleset.update(&update);
        }
        self.versions
            .entry(region)
            .or_insert_with(SplitVec::new)  // Use SplitVec::new
            .push(update);
    }

    pub fn check_transaction(&self, tx: &Transaction) -> Result<(), String> {
        let region_rules = self.rules.get(&tx.region).ok_or("No rules found for region")?;
        region_rules.validate(tx)
    }

    pub fn get_versions(&self, region: &String) -> Option<&SplitVec<RegulatoryUpdate>> {
        self.versions.get(region)
    }
}

impl RuleSet {
    pub fn update(&mut self, update: &RegulatoryUpdate) {
        // Logic to apply the regulatory update
    }
    }
