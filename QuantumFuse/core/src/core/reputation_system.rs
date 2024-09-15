// src/core/reputation_system.rs
pub struct Market {
    offers: HashMap<String, EnergyNFTListing>,
    subscriptions: HashMap<String, Subscription>,
    reputation: HashMap<String, f64>,
}

impl Market {
    pub fn new() -> Self {
        Market {
            offers: HashMap::new(),
            subscriptions: HashMap::new(),
            reputation: HashMap::new(),
        }
    }

    pub fn list_offer(&mut self, offer: EnergyNFTListing) {
        self.offers.insert(offer.token_id.clone(), offer);
    }

    pub fn subscribe(&mut self, subscription: Subscription) {
        self.subscriptions.insert(subscription.id.clone(), subscription);
    }

    pub fn match_requests(&mut self) {
        for (sub_id, sub) in &self.subscriptions {
            for (offer_id, offer) in &self.offers {
                if offer.asking_price <= sub.max_price_per_mj && offer.token_id == sub.token_id {
                    println!("Match found: Offer {} for Subscription {}", offer_id, sub_id);
                    self.update_reputation(&offer.owner, 1.0);
                    self.update_reputation(&sub.subscriber, 1.0);
                }
            }
        }
    }

    fn update_reputation(&mut self, user: &String, score: f64) {
        let entry = self.reputation.entry(user.clone()).or_insert(0.0);
        *entry += score;
    }

    pub fn get_reputation(&self, user: &String) -> f64 {
        *self.reputation.get(user).unwrap_or(&0.0)
    }
}
