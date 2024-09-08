mod blockchain;
mod wallet;
mod fusion_reactor;
mod nft;
mod marketplace;
mod sgx_enclave;
mod quantum_optimizer;
mod dao;
mod energydao;
mod fault_detection;
mod decentralized_identity;

use blockchain::{Blockchain, Transaction, SmartContract, MultiSigTransaction, Block};
use wallet::{CommunityWallet, FounderWallet};
use fusion_reactor::FusionReactor;
use nft::{FNFTContract, Fraction};
use marketplace::Marketplace;
use sgx_enclave::SgxEnclave;
use quantum_optimizer::QuantumOptimizer;
use dao::DAO;
use energydao::EnergyDAO;
use fault_detection::FaultDetection;
use decentralized_identity::{DecentralizedIdentity, IdentityAttributes};
use std::collections::HashMap;
use log::{info, warn, error};
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

    // Configuration management using environment variables
    let mining_difficulty: u32 = env::var("MINING_DIFFICULTY")
        .unwrap_or_else(|_| "4".to_string())
        .parse()
        .unwrap_or(4);

    let tx_limit: usize = env::var("TX_LIMIT")
        .unwrap_or_else(|_| "100".to_string())
        .parse()
        .unwrap_or(100);

    // Initialize core components with proper error handling
    let mut blockchain = Blockchain::new(mining_difficulty, tx_limit);
    let mut fnft_contract = FNFTContract::new();
    let mut fusion_reactor = FusionReactor::new();
    let mut marketplace = Marketplace::new();
    let mut energy_dao = EnergyDAO::new();
    let mut dao = DAO::new();
    let fault_detection = FaultDetection::new();
    let quantum_optimizer = QuantumOptimizer::new();

    // Handle SGX Enclave initialization with error handling
    let sgx_enclave = match SgxEnclave::initialize() {
        Ok(enclave) => enclave,
        Err(e) => {
            error!("Failed to initialize SGX enclave: {}", e);
            return Err(e.into());
        }
    };

    // Initialize wallets with error handling
    let community_wallet = match CommunityWallet::new() {
        Ok(wallet) => wallet,
        Err(e) => {
            error!("Failed to create community wallet: {}", e);
            return Err(e.into());
        }
    };

    let founder_wallet = match FounderWallet::new() {
        Ok(wallet) => wallet,
        Err(e) => {
            error!("Failed to create founder wallet: {}", e);
            return Err(e.into());
        }
    };

    // Example usage: Adding a simple transaction and mining it
    let tx = Transaction {
        sender: community_wallet.get_address(),
        receiver: "bob".to_string(),
        amount: 50,
        signature: String::new(),
    };
    blockchain.add_transaction(tx.clone());
    blockchain.mine_pending_transactions("miner_address");

    info!("Blockchain: {:?}", blockchain.blocks);

    // Example: Create and trade F-NFTs with error handling and retry logic
    let mut fractions = HashMap::new();
    fractions.insert("Alice".to_string(), Fraction { owner: "Alice".to_string(), percentage: 50.0 });
    fractions.insert("Bob".to_string(), Fraction { owner: "Bob".to_string(), percentage: 50.0 });
    let fnft_id = fnft_contract.create_fnft("nft_123", fractions);

    match fnft_contract.trade_fraction(&fnft_id, "Alice", "Charlie") {
        Ok(_) => info!("Fraction traded successfully!"),
        Err(e) => {
            warn!("Failed to trade fraction: {}", e);
            if let Err(retry_err) = fnft_contract.retry_fraction_trade(&fnft_id, "Alice", "Charlie") {
                error!("Retry failed: {}", retry_err);
            }
        }
    }

    // DAO and Governance example with error handling
    let proposal_id = dao.create_proposal("Increase energy efficiency reward", "Alice");
    dao.vote(proposal_id, "Alice", true);
    dao.vote(proposal_id, "Bob", false);

    if let Some((yes_votes, no_votes)) = dao.tally_votes(proposal_id) {
        info!("Proposal {}: Yes votes: {}, No votes: {}", proposal_id, yes_votes, no_votes);
        
        // Enhanced governance reporting
        let participation_rate = dao.get_participation_rate(proposal_id);
        info!("Participation Rate: {:.2}%", participation_rate * 100.0);
        
        if yes_votes > no_votes {
            info!("Proposal passed.");
        } else {
            info!("Proposal rejected.");
        }
    }

    // Fusion Reactor Example with activation and logging
    fusion_reactor.activate(0.9);
    info!("Fusion reactor activated with power level: {}", fusion_reactor.get_power_level());

    // Marketplace Example
    marketplace.list_item("energy_token", 100.0);
    if let Some(item) = marketplace.buy_item("energy_token") {
        info!("Bought item: {:?}", item);
    } else {
        warn!("Item not found in marketplace");
    }

    // Fault detection and energy dashboard example
    let mut dashboard = EnergyDashboard::new();
    dashboard.update_metrics("total_energy", blockchain.get_energy_metrics());
    dashboard.display_metrics();

    let faults = fault_detection.detect_faults(&dashboard.metrics);
    if faults.is_empty() {
        info!("System is healthy with no detected faults.");
    } else {
        for fault in faults {
            warn!("Detected fault: {}", fault);
        }
    }

    // Predict future faults with logging
    if fault_detection.predict_future_faults(&dashboard.metrics) {
        warn!("Warning: Future system faults predicted based on current metrics.");
    }

    // Cross-chain transfer example with error handling and retry logic
    let blockchain_interop = BlockchainInteroperability::new();
    match blockchain_interop.enable_cross_chain_transfer("EnergyToken", 100.0, "Ethereum") {
        Ok(_) => info!("Cross-chain transfer successful."),
        Err(e) => {
            error!("Cross-chain transfer failed: {}", e);
            if let Err(retry_err) = blockchain_interop.retry_cross_chain_transfer("EnergyToken", 100.0, "Ethereum") {
                error!("Retry failed: {}", retry_err);
            }
        }
    }

    // IPFS Storage Example with async handling
    match blockchain.store_data_on_ipfs("Hello, IPFS!".to_string()).await {
        Ok(hash) => info!("Stored data on IPFS with hash: {}", hash),
        Err(e) => error!("Failed to store data on IPFS: {}", e),
    }

    // Smart Contract example with enhanced error handling
    if blockchain.validate_contract_state("contract1") {
        let contract = SmartContract {
            id: "contract1".to_string(),
            code: "contract_code".to_string(),
            owner: "Alice".to_string(),
            state: HashMap::new(),
        };
        blockchain.deploy_smart_contract(contract);
        match blockchain.execute_smart_contract("contract1", "test_input") {
            Ok(result) => info!("Smart contract executed successfully: {}", result),
            Err(e) => {
                error!("Smart contract execution failed: {}", e);
                blockchain.log_failed_execution("contract1", e);
            }
        }
    } else {
        warn!("Smart contract is in an invalid state. Execution aborted.");
    }

    // Decentralized identity management
    let mut attributes = IdentityAttributes::new();
    attributes.insert("email".to_string(), "alice@example.com".to_string());
    let identity = DecentralizedIdentity::new("did:example:123456", "public_key", attributes);
    blockchain.register_identity(identity.clone());
    let identity_verified = blockchain.verify_identity(&identity.did, &identity.public_key);
    info!("Identity verified: {}", identity_verified);

    // Demonstrate creating a shard and adding a block to it
    blockchain.create_shard(1);
    let shard_block = Block::new(0, current_timestamp(), vec![tx.clone()], "0");
    blockchain.add_block_to_shard(1, shard_block);
    info!("Shard 1 blocks: {:?}", blockchain.shards.get(&1).unwrap().blocks);

    Ok(())
}
