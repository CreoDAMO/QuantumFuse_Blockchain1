pub struct Assessment {
    pub report: Report,
    pub scenarios: Vec<ResilienceScenario>,
}

impl Assessment {
    pub fn new() -> Self {
        Assessment {
            report: Report::new(),
            scenarios: vec![],
        }
    }

    pub fn evaluate(&mut self, system: &EnergySystem, scenario: ResilienceScenario) {
        self.scenarios.push(scenario);
        self.report.security = self.analyze_security(system);
        self.report.reliability = self.analyze_reliability(system);
    }

    pub fn generate_report(&self) -> String {
        // output report as string
        format!(
            "Security: {}\nReliability: {}\nScenarios: {:?}\n",
            self.report.security,
            self.report.reliability,
            self.scenarios
        )
    }

    fn analyze_security(&self, _system: &EnergySystem) -> String {
        // logic to analyze security
        "High".to_string()
    }

    fn analyze_reliability(&self, _system: &EnergySystem) -> String {
        // logic to analyze reliability
        "99.99%".to_string()
    }
}
