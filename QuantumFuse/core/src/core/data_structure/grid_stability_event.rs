pub struct GridStabilityEvent {
    time: String,
    location: String,
    cause: String,
    mitigation_actions: Vec<String>,
}

impl GridStabilityEvent {
    pub fn new(time: String, location: String, cause: String, mitigation_actions: Vec<String>) -> Self {
        GridStabilityEvent {
            time,
            location,
            cause,
            mitigation_actions,
        }
    }
}
