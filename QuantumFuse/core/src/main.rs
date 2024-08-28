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

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize the Blockchain
    let mut blockchain = Blockchain::new(4, 100);

    // Initialize Wallets
    let community_wallet = CommunityWallet::new()?;
    let founder_wallet = FounderWallet::new()?;

    // Initialize Fusion Reactor
    let fusion_reactor = FusionReactor::new();
    
    // Initialize NFT and F-NFT Contracts
    let nft_contract = NFTContract::new();
    let fnft_contract = FNFTContract::new();
    
    // Initialize Marketplace
    let marketplace = Marketplace::new();
    
    // Initialize SGX Enclave for secure operations
    let enclave = SgxEnclave::initialize()?;

    // Example usage: creating a transaction from the community wallet
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

    // Example: Trade in the Marketplace
    let energy_credit = marketplace::EnergyCredit::new("credit_1", 100.0, "Alice".to_string(), 10.0);
    marketplace.add_credit(energy_credit);
    
    // Example: Running secure operations in the SGX enclave
    enclave.run_secure_computation()?;

    // Additional logic to handle advanced features like cross-chain, decentralized identity, etc.

    Ok(())
}
