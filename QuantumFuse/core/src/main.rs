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
use nft::{NFTContract, FNFTContract, Fraction};
use marketplace::Marketplace;
use sgx_enclave::SgxEnclave;
use quantum_optimizer::QuantumOptimizer;
use dao::DAO;
use energydao::EnergyDAO;
use fault_detection::FaultDetection;
use decentralized_identity::DecentralizedIdentity;
use std::collections::HashMap;
use orx_split_vec::SplitVec;
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize core components
    let mut blockchain = Blockchain::new(4, 100);
    let mut fnft_contract = FNFTContract::new();
    let mut energy_manager = EnergyManager::new(EnergyStorageSystem::new(1000.0, 50.0, 50.0));
    let mut energy_dao = EnergyDAO::new();
    let quantum_optimizer = QuantumOptimizer::new();
    let mut dao = DAO::new();
    let mut fault_detection = FaultDetection::new();
    let sgx_enclave = SgxEnclave::initialize()?;

    // Initialize wallets
    let community_wallet = CommunityWallet::new()?;
    let founder_wallet = FounderWallet::new()?;

    // Energy management example
    energy_manager.manage_storage(200.0, 150.0);
    println!("Storage status: {}%", energy_manager.get_storage_status() * 100.0);

    // Multisignature transaction example
    let multisig_tx = MultiSigTransaction {
        sender: "Alice".to_string(),
        receivers: vec!["Bob".to_string(), "Charlie".to_string()],
        amount: 20,
        signatures: vec!["signature1".to_string(), "signature2".to_string()],
    };
    blockchain.add_multisig_transaction(multisig_tx);

    // Example usage: Adding a simple transaction and mining it
    let tx = Transaction {
        sender: community_wallet.get_address(),
        receiver: "recipient_address".to_string(),
        amount: 50,
        signature: String::new(),
    };
    community_wallet.sign_transaction(&mut tx)?;
    blockchain.add_transaction(tx.clone());

    blockchain.mine_pending_transactions("miner_address");
    println!("Blockchain: {:?}", blockchain.blocks);

    // Example: Create and trade F-NFTs with governance
    let original_nft_id = "nft_123";
    let mut fractions = HashMap::new();
    fractions.insert("Alice".to_string(), Fraction { owner: "Alice".to_string(), percentage: 50.0 });
    fractions.insert("Bob".to_string(), Fraction { owner: "Bob".to_string(), percentage: 50.0 });
    let fnft_id = fnft_contract.create_fnft(original_nft_id, fractions);

    match fnft_contract.trade_fraction(&fnft_id, "Alice", "Charlie") {
        Ok(_) => println!("Fraction traded successfully!"),
        Err(e) => {
            println!("Failed to trade fraction: {}", e);
            // Retry logic or log error
            fnft_contract.retry_fraction_trade(&fnft_id, "Alice", "Charlie");
        }
    }

    // DAO and Governance example
    let proposal_id = dao.create_proposal("Increase energy efficiency reward", "Alice");
    dao.vote(proposal_id, "Alice", true);
    dao.vote(proposal_id, "Bob", false);

    if let Some((yes_votes, no_votes)) = dao.tally_votes(proposal_id) {
        println!("Proposal {}: Yes votes: {}, No votes: {}", proposal_id, yes_votes, no_votes);
        
        // Enhanced governance reporting
        let participation_rate = dao.get_participation_rate(proposal_id);
        println!("Participation Rate: {:.2}%", participation_rate * 100.0);
        
        if yes_votes > no_votes {
            println!("Proposal passed.");
        } else {
            println!("Proposal rejected.");
        }
    }

    // Fault detection and energy dashboard example
    let mut dashboard = EnergyDashboard::new();
    dashboard.update_metrics("total_energy", blockchain.get_energy_metrics());
    dashboard.display_metrics();

    let faults = fault_detection.detect_faults(&dashboard.metrics);
    if faults.is_empty() {
        println!("System is healthy with no detected faults.");
    } else {
        for fault in faults {
            println!("Detected fault: {}", fault);
        }
    }

    // Predict future faults
    if fault_detection.predict_future_faults(&dashboard.metrics) {
        println!("Warning: Future system faults predicted based on current metrics.");
    }

    // Cross-chain transfer with Blockchain Interoperability
    let blockchain_interop = BlockchainInteroperability::new();
    match blockchain_interop.enable_cross_chain_transfer("EnergyToken", 100.0, "Ethereum") {
        Ok(_) => println!("Cross-chain transfer successful."),
        Err(e) => {
            println!("Cross-chain transfer failed: {}", e);
            // Fallback logic: Retry the cross-chain transfer
            blockchain_interop.retry_cross_chain_transfer("EnergyToken", 100.0, "Ethereum")?;
        }
    }

    // IPFS Storage Example
    let result = blockchain.store_data_on_ipfs("Hello, IPFS!".to_string()).await;
    match result {
        Ok(hash) => println!("Stored data on IPFS with hash: {}", hash),
        Err(e) => println!("Failed to store data on IPFS: {}", e),
    }

    // Smart Contract example
    if blockchain.validate_contract_state("contract1") {
        let contract = SmartContract {
            id: "contract1".to_string(),
            code: "contract_code".to_string(),
            owner: "Alice".to_string(),
            state: HashMap::new(),
        };
        blockchain.deploy_smart_contract(contract);
        match blockchain.execute_smart_contract("contract1", "test_input") {
            Ok(result) => println!("Smart contract executed successfully: {}", result),
            Err(e) => {
                println!("Smart contract execution failed: {}", e);
                // Fallback or log the failure for auditing
                blockchain.log_failed_execution("contract1", e);
            }
        }
    } else {
        println!("Smart contract is in an invalid state. Execution aborted.");
    }

    // Identity Verification Example
    let mut attributes = HashMap::new();
    attributes.insert("email".to_string(), "alice@example.com".to_string());
    let identity = DecentralizedIdentity {
        did: "did:example:123456".to_string(),
        public_key: "public_key".to_string(),
        attributes,
    };
    blockchain.register_identity(identity.clone());
    let identity_verified = blockchain.verify_identity(&identity.did, &identity.public_key);
    println!("Identity verified: {}", identity_verified);

    // Demonstrate creating a shard and adding a block to it
    blockchain.create_shard(1);
    let shard_block = Block::new(0, current_timestamp(), vec![tx.clone()], "0");
    blockchain.add_block_to_shard(1, shard_block);
    println!("Shard 1 blocks: {:?}", blockchain.shards.get(&1).unwrap().blocks);

    Ok(())
}
