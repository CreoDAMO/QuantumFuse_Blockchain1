use ring::signature::{Ed25519KeyPair, KeyPair};
use serde::{Serialize, Deserialize};
use std::collections::HashMap;
use thiserror::Error;
use std::fs;

mod wallet;

use wallet::{Wallet, Transaction, WalletError, generate_did};

#[tokio::main]
async fn main() -> Result<(), WalletError> {
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

    // Save wallet to file
    wallet.save_to_file("wallet.json")?;

    // Load wallet from file
    let loaded_wallet = Wallet::load_from_file("wallet.json")?;
    println!("Loaded wallet: {:?}", loaded_wallet);

    Ok(())
}
