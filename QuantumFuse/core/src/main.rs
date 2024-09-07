mod blockchain;
mod wallet;
mod fusion_reactor;
mod nft;
mod marketplace;
mod sgx_enclave;

use blockchain::{Blockchain, Transaction};
use wallet::{CommunityWallet, FounderWallet};
use fusion_reactor::FusionReactor;
use nft::{NFTContract, FNFTContract};
use marketplace::Marketplace;
use sgx_enclave::SgxEnclave;
use orx_split_vec::SplitVec;  // Import SplitVec to replace standard Vec
use std::collections::HashMap;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize the Blockchain with difficulty 4 and reward 100
    let mut blockchain = Blockchain::new(4, 100);

    // Initialize Wallets
    let community_wallet = CommunityWallet::new()?;
    let founder_wallet = FounderWallet::new()?;

    // Initialize Fusion Reactor
    let fusion_reactor = FusionReactor::new();

    // Initialize NFT and F-NFT Contracts
    let nft_contract = NFTContract::new();
    let mut fnft_contract = FNFTContract::new();

    // Initialize Marketplace
    let marketplace = Marketplace::new();

    // Initialize SGX Enclave for secure operations
    let enclave = SgxEnclave::initialize()?;

    // Initialize energy management
    let mut energy_manager = EnergyManager::new(EnergyStorageSystem::new(1000.0, 50.0, 50.0));

    // Example usage of energy manager
    energy_manager.manage_storage(200.0, 150.0);
    println!("Storage status: {}%", energy_manager.get_storage_status() * 100.0);

    // Example: creating a transaction from the community wallet
    let mut tx = Transaction {
        sender: community_wallet.get_address(),
        recipient: "recipient_address".to_string(),
        amount: 50,
        timestamp: 1629814920,
        signature: String::new(),
    };
    community_wallet.sign_transaction(&mut tx)?;
    blockchain.add_transaction(tx);

    // Example: Mining the transaction
    match blockchain.mine_pending_transactions("miner_address") {
        Ok(_) => println!("Block mined successfully!"),
        Err(e) => println!("Failed to mine block: {}", e),
    }

    // Example: Minting an NFT
    let nft_metadata = nft_contract.generate_metadata(&blockchain);
    let nft_id = nft_contract.mint_nft("Alice", &nft_metadata);
    println!("Minted NFT with ID: {}", nft_id);

    // Example: Creating and managing F-NFTs
    let original_nft_id = "nft_123";
    let mut fractions = HashMap::new();
    fractions.insert("Alice".to_string(), Fraction { owner: "Alice".to_string(), percentage: 50.0 });
    fractions.insert("Bob".to_string(), Fraction { owner: "Bob".to_string(), percentage: 50.0 });

    let fnft_id = fnft_contract.create_fnft(original_nft_id, fractions);
    println!("Created FNFT with ID: {}", fnft_id);

    match fnft_contract.trade_fraction(&fnft_id, "Alice", "Charlie") {
        Ok(_) => println!("Fraction traded successfully!"),
        Err(e) => println!("Failed to trade fraction: {}", e),
    }

    if let Some(fnft) = fnft_contract.get_fnft_details(&fnft_id) {
        println!("FNFT Details: {:?}", fnft);
    }

    // Example: Trade in the Marketplace
    let energy_credit = marketplace::EnergyCredit::new("credit_1", 100.0, "Alice".to_string(), 10.0);
    marketplace.add_credit(energy_credit);

    // Example: Optimizing fusion reactor performance
    let performance_optimization = blockchain.optimize_fusion_performance();
    println!("Fusion reactor performance optimization: {}", performance_optimization);

    // Example: Running secure operations in the SGX enclave
    enclave.run_secure_computation()?;

    // Example usage of quantum optimizer
    let quantum_optimizer = QuantumOptimizer::new();
    let optimized_distribution = quantum_optimizer.optimize_energy_distribution(&[100.0, 200.0], &[150.0, 250.0]);
    println!("Optimized energy distribution: {:?}", optimized_distribution);

    // Example: Cross-chain transfer
    let blockchain_interop = BlockchainInteroperability::new();
    match blockchain_interop.enable_cross_chain_transfer("EnergyToken", 100.0, "Ethereum") {
        Ok(_) => println!("Cross-chain transfer successful"),
        Err(e) => println!("Cross-chain transfer failed: {}", e),
    }

    // Example usage of DAO voting
    let mut dao = DAO::new();
    let proposal_id = dao.create_proposal("Increase energy efficiency reward", "Alice");
    dao.vote(proposal_id, "Alice", true);
    dao.vote(proposal_id, "Bob", false);

    if let Some((yes_votes, no_votes)) = dao.tally_votes(proposal_id) {
        println!("Proposal {}: Yes votes: {}, No votes: {}", proposal_id, yes_votes, no_votes);
    }

    // Example: Storing data on IPFS
    let result = blockchain.store_data_on_ipfs("Hello, IPFS!").await;
    match result {
        Ok(hash) => println!("Stored data on IPFS with hash: {}", hash),
        Err(e) => println!("Failed to store data on IPFS: {}", e),
    }

    Ok(())
}
