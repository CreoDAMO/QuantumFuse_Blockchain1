// src/core/advanced_analytics.rs
pub fn generate_insights(portfolio: &std::collections::HashMap<String, f64>) -> Result<SplitVec<Insight>, Box<dyn std::error::Error>> {
    Ok(SplitVec::new())  // Use SplitVec instead of vec
}

pub struct Insight {
    pub recommendation: String,
}

pub fn predict_market_trends(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    Ok("Market trend".to_string())
}
