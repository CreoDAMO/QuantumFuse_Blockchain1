use orx_split_vec::SplitVec;  // Import SplitVec

pub struct Assessment {
    pub report: Report,
    pub scenarios: SplitVec<ResilienceScenario>,  // Use SplitVec instead of Vec
}

impl Assessment {
    pub fn new() -> Self {
        Assessment {
            report: Report::new(),
            scenarios: SplitVec::new(),  // Initialize with SplitVec
        }
    }

    pub fn evaluate(&mut self, system: &EnergySystem, scenario: ResilienceScenario) {
        self.scenarios.push(scenario);
        self.report.security = self.analyze_security(system);
        self.report.reliability = self.analyze_reliability(system);
    }

    pub fn generate_report(&self) -> String {
        format!(
            "Security: {}\nReliability: {}\nScenarios: {:?}\n",
            self.report.security,
            self.report.reliability,
            self.scenarios
        )
    }

    fn analyze_security(&self, _system: &EnergySystem) -> String {
        "High".to_string()
    }

    fn analyze_reliability(&self, _system: &EnergySystem) -> String {
        "99.99%".to_string()
    }
}
