pub struct Compliance {
    rules: HashMap<String, RuleSet>,
    versions: HashMap<String, Vec<RegulatoryUpdate>>,
}

impl Compliance {
    pub fn new() -> Self {
        Compliance {
            rules: HashMap::new(),
            versions: HashMap::new(),
        }
    }

    pub fn update_rules(&mut self, region: String, update: RegulatoryUpdate) {
        self.rules.get_mut(&region).map(|ruleset| ruleset.update(&update));
        self.versions.entry(region).or_insert(vec![]).push(update);
    }

    pub fn check_transaction(&self, tx: &Transaction) -> Result<(), String> {
        let region_rules = self.rules.get(&tx.region).ok_or("No rules found for region")?;
        region_rules.validate(tx)
    }

    pub fn get_versions(&self, region: &String) -> Option<&Vec<RegulatoryUpdate>> {
        self.versions.get(region)
    }
}

impl RuleSet {
    pub fn update(&mut self, update: &RegulatoryUpdate) {
        // logic to apply the regulatory update
    }
}
