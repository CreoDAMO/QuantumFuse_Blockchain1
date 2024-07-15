pub struct ResilienceScenario {
    disaster_type: String,
    affected_infrastructure: String,
    expected_impact: String,
}

impl ResilienceScenario {
    pub fn new(disaster_type: String, affected_infrastructure: String, expected_impact: String) -> Self {
        ResilienceScenario {
            disaster_type,
            affected_infrastructure,
            expected_impact,
        }
    }
}
