// QuantumFuse/core/src/main.rs
// Import necessary modules from core
mod blockchain;
mod community_wallet_mod;
mod founder_wallets_mods;
mod fusion;
mod fnft;
mod marketplace;
mod dao;
mod energy_dao;
mod decentralized_identity;
mod sgx;
mod ipfs_api;
mod social_recovery;
mod integration_of_quantum_inspired_algorithm;

use blockchain::{Blockchain, Transaction, SmartContract, Block};
use community_wallet_mod::Wallet as CommunityWallet;
use founder_wallets_mods::Wallet as FounderWallet;
use fusion::FusionReactor;
use fnft::{FNFTContract, Fraction};
use marketplace::Marketplace;
use dao::Dao;
use energy_dao::EnergyDAO;
use decentralized_identity::{generate_did_key, issue_verifiable_credential};
use sgx::initialize_sgx_enclave;
use ipfs_api::store_data_on_ipfs;
use log::{info, error};
use dotenv::dotenv;
use std::env;
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Load environment variables from .env file
    dotenv().ok();

    // Initialize logging
    env_logger::init();
    info!("Starting QuantumFuse Blockchain...");

    // Configuration: mining difficulty, transaction limit, etc.
    let mining_difficulty: u32 = env::var("MINING_DIFFICULTY").unwrap_or_else(|_| "4".to_string()).parse().unwrap_or(4);
    let tx_limit: usize = env::var("TX_LIMIT").unwrap_or_else(|_| "100".to_string()).parse().unwrap_or(100);

    // Initialize core components
    let mut blockchain = Blockchain::new(mining_difficulty, tx_limit);
    let mut fnft_contract = FNFTContract::new();
    let mut fusion_reactor = FusionReactor::new();
    let mut marketplace = Marketplace::new();
    let mut energy_dao = EnergyDAO::new();
    let mut dao = Dao::new();

    // Initialize SGX Enclave for secure operations
    match initialize_sgx_enclave() {
        Ok(_) => info!("SGX Enclave initialized successfully."),
        Err(e) => {
            error!("Failed to initialize SGX Enclave: {}", e);
            return Err(e.into());
        }
    }

    // Wallets initialization
    let community_wallet = CommunityWallet::new();
    let founder_wallet = FounderWallet::new();

    // Create a simple transaction and mine it
    let tx = Transaction {
        sender: community_wallet.get_address(),
        receiver: "bob".to_string(),
        amount: 50,
        signature: String::new(),
    };
    blockchain.add_transaction(tx.clone());
    blockchain.mine_pending_transactions("miner_address");

    // FNFT Example: Create and trade fractional NFTs
    let mut fractions = vec![
        Fraction { owner: "Alice".to_string(), percentage: 50.0 },
        Fraction { owner: "Bob".to_string(), percentage: 50.0 },
    ];
    let fnft_id = fnft_contract.create_fnft("nft_123", fractions);
    match fnft_contract.trade_fraction(&fnft_id, "Alice", "Charlie") {
        Ok(_) => info!("FNFT fraction traded successfully."),
        Err(e) => error!("Failed to trade FNFT fraction: {}", e),
    }

    // Marketplace: Trade energy credits
    marketplace.list_item("energy_token", 100.0);
    if let Some(item) = marketplace.buy_item("energy_token") {
        info!("Energy token bought: {:?}", item);
    } else {
        error!("Energy token not found in marketplace.");
    }

    // DAO Voting Example
    let proposal_id = dao.create_proposal("Increase energy efficiency reward", "Alice".to_string(), vec!["Yes".to_string(), "No".to_string()]);
    dao.vote(proposal_id, "Alice".to_string(), "Yes".to_string());
    dao.vote(proposal_id, "Bob".to_string(), "No".to_string());

    if let Some((yes_votes, no_votes)) = dao.tally_votes(proposal_id) {
        info!("Proposal {}: Yes votes: {}, No votes: {}", proposal_id, yes_votes, no_votes);
    }

    // EnergyDAO Example
    let energy_proposal_id = energy_dao.create_proposal(Proposal::new(1, "Increase energy credits".to_string()));
    energy_dao.vote_on_proposal(energy_proposal_id, "Alice".to_string(), true);
    if let Some((yes_votes, no_votes)) = energy_dao.tally_votes(energy_proposal_id) {
        info!("Energy Proposal {}: Yes votes: {}, No votes: {}", energy_proposal_id, yes_votes, no_votes);
    }

    // Decentralized Identity and Verifiable Credentials
    let did = generate_did_key()?;
    let credential = issue_verifiable_credential("Alice", "Energy usage verified")?;
    let credential_verified = decentralized_identity::verify_verifiable_credential(&credential)?;
    info!("Verifiable Credential Valid: {}", credential_verified);

    // IPFS Storage Example
    match store_data_on_ipfs("Hello, IPFS!".to_string()).await {
        Ok(hash) => info!("Stored data on IPFS with hash: {}", hash),
        Err(e) => error!("Failed to store data on IPFS: {}", e),
    }

    Ok(())
}
