use orx_split_vec::SplitVec;  // Import SplitVec

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
