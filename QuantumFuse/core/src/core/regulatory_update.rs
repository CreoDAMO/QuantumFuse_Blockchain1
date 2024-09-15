// src/core/regulatory_update.rs
pub struct RegulatoryUpdate {
    regulation_id: String,
    updated_text: String,
    effective_date: String,
}

impl RegulatoryUpdate {
    pub fn new(regulation_id: String, updated_text: String, effective_date: String) -> Self {
        RegulatoryUpdate {
            regulation_id,
            updated_text,
            effective_date,
        }
    }
}
