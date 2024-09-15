// src/core/energy_forecast.rs
pub struct EnergyForecast {
    predicted_demand: SplitVec<f64>,        // Using SplitVec for predicted demand
    recommended_fuel_supply: SplitVec<f64>, // Using SplitVec for fuel supply
    maintenance_schedule: SplitVec<String>, // Using SplitVec for maintenance schedule
    cost_estimate: f64,
    environmental_impact: f64,
}

impl EnergyForecast {
    pub fn new() -> Self {
        EnergyForecast {
            predicted_demand: SplitVec::new(),        // Initialize SplitVec for predicted demand
            recommended_fuel_supply: SplitVec::new(), // Initialize SplitVec for fuel supply
            maintenance_schedule: SplitVec::new(),    // Initialize SplitVec for maintenance schedule
            cost_estimate: 0.0,
            environmental_impact: 0.0,
        }
    }

    pub fn add_predicted_demand(&mut self, demand: f64) {
        self.predicted_demand.push(demand);
    }

    pub fn add_fuel_supply(&mut self, supply: f64) {
        self.recommended_fuel_supply.push(supply);
    }

    pub fn add_maintenance_schedule(&mut self, schedule: String) {
        self.maintenance_schedule.push(schedule);
    }

    pub fn calculate_cost_estimate(&mut self, unit_cost: f64) {
        self.cost_estimate = self.predicted_demand.iter().sum::<f64>() * unit_cost;
    }

    pub fn calculate_environmental_impact(&mut self, impact_factor: f64) {
        self.environmental_impact = self.recommended_fuel_supply.iter().sum::<f64>() * impact_factor;
    }
        }
