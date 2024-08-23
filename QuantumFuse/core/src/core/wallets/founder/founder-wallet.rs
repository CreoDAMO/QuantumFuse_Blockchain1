mod wallet;
mod plaid;
mod yodlee;
mod morphic_ui;
mod self_sovereign;
mod ai_analytics;
mod investment;
mod anonymous_credentials;
mod zk_snark;
mod multiparty;
mod sgx;
mod substrate;
mod dao;
mod digital_identity;
mod regulation_monitor;
mod portfolio;
mod data_policy;
mod verifiable_credentials;
mod coinmarketcap_api;
mod coinbase_api;
mod biometric_auth;
mod cross_chain;
mod automation;
mod dex;
mod integrations;
mod decentralized_identity;
mod social_recovery;
mod advanced_analytics;
mod cross_platform;

use wallet::*;
use plaid::*;
use yodlee::*;
use morphic_ui::*;
use self_sovereign::*;
use ai_analytics::*;
use investment::*;
use anonymous_credentials::*;
use zk_snark::*;
use multiparty::*;
use sgx::*;
use substrate::*;
use dao::*;
use digital_identity::*;
use regulation_monitor::*;
use portfolio::*;
use data_policy::*;
use verifiable_credentials::*;
use coinmarketcap_api::*;
use coinbase_api::*;
use biometric_auth::*;
use cross_chain::*;
use automation::*;
use dex::*;
use integrations::*;
use decentralized_identity::*;
use social_recovery::*;
use advanced_analytics::*;
use cross_platform::*;
use sgx_types::*;
use sgx_urts::SgxEnclave;

static ENCLAVE_FILE: &str = "enclave.signed.so";

#[tokio::main]
async fn main() -> Result<(), WalletError> {
    // Initialize SGX enclave
    let enclave = SgxEnclave::create(ENCLAVE_FILE).expect("Failed to create SGX enclave");

    // Example usage of the Wallet
    let secret_key = vec![0u8; 32]; // Replace with actual secret key
    let mut wallet = Wallet::new(secret_key)?;

    // Create and sign a transaction
    let mut tx = Transaction {
        sender: wallet.address.clone(),
        recipient: "recipient_address".to_string(),
        amount: 100,
        timestamp: 1629814920,
        signature: String::new(),
    };

    wallet.sign_transaction(&mut tx, &secret_key)?;

    // Verify the transaction
    let is_valid = wallet.verify_transaction(&tx)?;
    println!("Transaction valid: {}", is_valid);

    // Other operations related to the founder wallet

    Ok(())
}
