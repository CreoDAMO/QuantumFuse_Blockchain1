// src/core/energy_storage_system.rs
pub struct EnergyStorageSystem {
    capacity: f64,
    charge_rate: f64,
    discharge_rate: f64,
    state_of_charge: f64,
}

impl EnergyStorageSystem {
    pub fn new(capacity: f64, charge_rate: f64, discharge_rate: f64) -> Self {
        EnergyStorageSystem {
            capacity,
            charge_rate,
            discharge_rate,
            state_of_charge: 0.0,
        }
    }

    pub fn get_state_of_charge(&self) -> f64 {
        self.state_of_charge
    }

    pub fn charge(&mut self, amount: f64) {
        self.state_of_charge = (self.state_of_charge + amount).min(self.capacity);
    }

    pub fn discharge(&mut self, amount: f64) {
        self.state_of_charge = (self.state_of_charge - amount).max(0.0);
    }
}
```

#### Enhancement: Optimal Management Algorithms
```rust
pub struct EnergyManager {
    storage_system: EnergyStorageSystem,
}

impl EnergyManager {
    pub fn new(storage_system: EnergyStorageSystem) -> Self {
        EnergyManager { storage_system }
    }

    pub fn manage_storage(&mut self, supply: f64, demand: f64) {
        if supply > demand {
            let excess = supply - demand;
            self.storage_system.charge(excess.min(self.storage_system.charge_rate));
        } else {
            let shortage = demand - supply;
            self.storage_system.discharge(shortage.min(self.storage_system.discharge_rate));
        }
    }

    pub fn get_storage_status(&self) -> f64 {
        self.storage_system.get_state_of_charge()
    }
}
