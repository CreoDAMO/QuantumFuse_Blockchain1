// src/core/grid_stability_event.rs
pub struct GridStabilityEvent {
    time: String,
    location: String,
    cause: String,
    mitigation_actions: SplitVec<String>,  // Replace Vec with SplitVec
}

impl GridStabilityEvent {
    pub fn new(time: String, location: String, cause: String, mitigation_actions: SplitVec<String>) -> Self {
        GridStabilityEvent {
            time,
            location,
            cause,
            mitigation_actions,
        }
    }
}
