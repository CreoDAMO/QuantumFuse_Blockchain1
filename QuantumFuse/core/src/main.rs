#[tokio::main]
async fn main() {
    let mut blockchain = Blockchain::new(4, 100);
    let mut dashboard = EnergyDashboard::new();
    let mut fault_detection = FaultDetection::new();
    let mut dao = DAO::new();
    let mut fnft_contract = FNFTContract::new();
    let mut energy_manager = EnergyManager::new(EnergyStorageSystem::new(1000.0, 50.0, 50.0));
    let mut energy_dao = EnergyDAO::new();
    let quantum_optimizer = QuantumOptimizer::new();
    let blockchain_interop = BlockchainInteroperability::new();
    let mut incentive_system = IncentiveSystem::new();

    // Example usage of energy manager
    energy_manager.manage_storage(200.0, 150.0);
    println!("Storage status: {}%", energy_manager.get_storage_status() * 100.0);

    // Example usage of DAO
    energy_dao.add_member("Alice".to_string());
    energy_dao.add_member("Bob".to_string());
    let proposal = Proposal::new(1, "Increase energy storage capacity".to_string());
    energy_dao.create_proposal(proposal);
    energy_dao.vote_on_proposal(0, "Alice".to_string(), true);
    energy_dao.vote_on_proposal(0, "Bob".to_string(), false);

    if let Some((yes_votes, no_votes)) = energy_dao.tally_votes(0) {
        println!("Proposal 0: Yes votes: {}, No votes: {}", yes_votes, no_votes);
    }

    // Example usage of quantum optimizer
    let optimized_distribution = quantum_optimizer.optimize_energy_distribution(&[100.0, 200.0], &[150.0, 250.0]);
    println!("Optimized energy distribution: {:?}", optimized_distribution);

    // Example usage of blockchain interoperability
    match blockchain_interop.enable_cross_chain_transfer("EnergyToken", 100.0, "Ethereum") {
        Ok(_) => println!("Cross-chain transfer successful"),
        Err(e) => println!("Cross-chain transfer failed: {}", e),
    }

    // Example usage of incentive system
    incentive_system.reward("Alice".to_string(), 50.0);
    if let Some(token) = incentive_system.get_token("token_1") {
        println!("Token ID: {}, Owner: {}, Amount: {}", token.token_id, token.owner, token.amount);
    }

    // Example usage of fault detection and dashboard
    let tx = Transaction {
        sender: "Alice".to_string(),
        receiver: "Bob".to_string(),
        amount: 10,
        signature: "signature".to_string(),
    };
    blockchain.add_transaction(tx);

    match blockchain.mine_pending_transactions("miner_address") {
        Ok(_) => println!("Block mined successfully!"),
        Err(e) => println!("Failed to mine block: {}", e),
    }

    println!("Blockchain: {:?}", blockchain.blocks);
    println!("Total energy consumed: {} MJ", blockchain.get_energy_metrics());

    dashboard.update_metrics("total_energy", blockchain.get_energy_metrics());
    dashboard.display_metrics();

    let faults = fault_detection.detect_faults(&dashboard.metrics);
    for fault in faults {
        println!("{}", fault);
    }

    let proposal_id = dao.create_proposal("Increase energy efficiency reward", "Alice");
    dao.vote(proposal_id, "Alice", true);
    dao.vote(proposal_id, "Bob", false);

    if let Some((yes_votes, no_votes)) = dao.tally_votes(proposal_id) {
        println!("Proposal {}: Yes votes: {}, No votes: {}", proposal_id, yes_votes, no_votes);
    }

    let result = blockchain.store_data_on_ipfs("Hello, IPFS!").await;
    match result {
        Ok(hash) => println!("Stored data on IPFS with hash: {}", hash),
        Err(e) => println!("Failed to store data on IPFS: {}", e),
    }

    // Deploy and execute a smart contract
    let mut contract = SmartContract::new("contract1", "dummy_code", "Alice");
    blockchain.deploy_smart_contract(contract);

    match blockchain.execute_smart_contract("contract1", "test_input") {
        Ok(result) => println!("Smart contract execution result: {}", result),
        Err(e) => println!("Smart contract execution failed: {}", e),
    }

    contract.update_state("energy_reward", "150");
    if let Some(reward) = contract.get_state("energy_reward") {
        println!("Energy reward state: {}", reward);
    }

    // Optimize fusion reactor performance
    let performance_optimization = blockchain.optimize_fusion_performance();
    println!("Fusion reactor performance optimization: {}", performance_optimization);

    // Generate and mint an NFT with live metadata
    let nft_metadata = generate_metadata(&blockchain);
    let nft_id = blockchain.nft_contract.mint_nft("Alice", &nft_metadata);
    println!("Minted NFT with ID: {}", nft_id);

    // Create and manage F-NFTs
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
        }
            
