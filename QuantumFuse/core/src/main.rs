mod core; // your core modules
mod wallet;

use core::*;
use wallet::*;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Main application logic here
    Ok(())
}
