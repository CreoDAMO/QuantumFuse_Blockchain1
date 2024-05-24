use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::HashMap;
use ipfs_api::{IpfsClient, IpfsApi, TryFromUri};
use std::io::Cursor;
use tokio;
use std::str::FromStr;
use hex;

#[derive(Clone, Debug, Serialize, Deserialize)]
struct Transaction {
    sender: String,
    receiver: String,
    amount: u64,
    signature: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct MultiSigTransaction {
    sender: String,
    receivers: Vec<String>,
    amount: u64,
    signatures: Vec<String>,
}

impl MultiSigTransaction {
    fn is_valid(&self) -> bool {
        self.signatures.len() >= self.receivers.len() / 2 + 1
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct Block {
    index: u64,
    timestamp: u128,
    transactions: Vec<Transaction>,
    previous_hash: String,
    nonce: u64,
    hash: String,
}

impl Block {
    fn new(index: u64, timestamp: u128, transactions: Vec<Transaction>, previous_hash: &str) -> Block {
        let mut block = Block {
            index,
            timestamp,
            transactions,
            previous_hash: previous_hash.to_string(),
            nonce: 0,
            hash: String::new(),
        };
        block.hash = block.calculate_hash();
        block
    }

    fn calculate_hash(&self) -> String {
        let data = format!("{}{}{:?}{}{}", self.index, self.timestamp, self.transactions, self.previous_hash, self.nonce);
        let mut hasher = Sha256::new();
        hasher.update(data.as_bytes());
        hex::encode(hasher.finalize())
    }

    fn mine_block(&mut self, difficulty: usize) {
        while &self.hash[..difficulty] != "0".repeat(difficulty) {
            self.nonce += 1;
            self.hash = self.calculate_hash();
        }
    }
}

#[derive(Serialize, Deserialize)]
struct Proposal {
    id: u64,
    title: String,
    description: String,
    options: Vec<String>,
    votes: HashMap<String, String>, // changed to map voter to option
    deadline: u128,
}

struct Governance {
    proposals: Vec<Proposal>,
    proposal_count: u64,
}

impl Governance {
    fn new() -> Self {
        Governance {
            proposals: vec![],
            proposal_count: 0,
        }
    }

    fn create_proposal(&mut self, title: String, description: String, options: Vec<String>, deadline: u128) {
        let proposal = Proposal {
            id: self.proposal_count,
            title,
            description,
            options,
            votes: HashMap::new(),
            deadline,
        };
        self.proposals.push(proposal);
        self.proposal_count += 1;
    }

    fn vote(&mut self, proposal_id: u64, option: String, voter: String) {
        if let Some(proposal) = self.proposals.iter_mut().find(|p| p.id == proposal_id) {
            if proposal.votes.contains_key(&voter) {
                println!("Voter has already voted.");
            } else {
                proposal.votes.insert(voter, option);
            }
        } else {
            println!("Proposal not found.");
        }
    }

    fn get_results(&self, proposal_id: u64) -> Option<HashMap<String, u64>> {
        if let Some(proposal) = self.proposals.iter().find(|p| p.id == proposal_id) {
            let mut results = HashMap::new();
            for option in &proposal.options {
                results.insert(option.clone(), 0);
            }
            for option in proposal.votes.values() {
                if let Some(count) = results.get_mut(option) {
                    *count += 1;
                }
            }
            Some(results)
        } else {
            None
        }
    }
}

#[derive(Clone, Debug, Serialize, Deserialize)]
struct SmartContract {
    id: String,
    code: String,
    owner: String,
    state: HashMap<String, String>,
}

impl SmartContract {
    fn execute(&mut self, input: &str) -> String {
        // Execute contract logic and update state
        self.state.insert("last_input".to_string(), input.to_string());
        "Executed with input".to_string()
    }
}

#[derive(Clone)]
struct Shard {
    shard_id: u64,
    blocks: Vec<Block>,
}

#[derive(Clone)]
struct DecentralizedIdentity {
    did: String,
    public_key: String,
    attributes: HashMap<String, String>,
}

struct QuantumFuseBlockchain {
    blocks: Vec<Block>,
    difficulty: usize,
    pending_transactions: Vec<Transaction>,
    multisig_transactions: Vec<MultiSigTransaction>,
    mining_reward: u64,
    staking_pool: HashMap<String, u64>,
    governance: Governance,
    smart_contracts: HashMap<String, SmartContract>,
    shards: HashMap<u64, Shard>,
    identities: HashMap<String, DecentralizedIdentity>,
}

impl QuantumFuseBlockchain {
    fn new(difficulty: usize, mining_reward: u64) -> Self {
        let mut blockchain = QuantumFuseBlockchain {
            blocks: Vec::new(),
            difficulty,
            pending_transactions: Vec::new(),
            multisig_transactions: Vec::new(),
            mining_reward,
            staking_pool: HashMap::new(),
            governance: Governance::new(),
            smart_contracts: HashMap::new(),
            shards: HashMap::new(),
            identities: HashMap::new(),
        };
        let genesis_block = Block::new(0, current_timestamp(), vec![], "0");
        blockchain.blocks.push(genesis_block);
        blockchain
    }

    fn add_transaction(&mut self, transaction: Transaction) {
        self.pending_transactions.push(transaction);
    }

    fn add_multisig_transaction(&mut self, transaction: MultiSigTransaction) {
        if transaction.is_valid() {
            self.multisig_transactions.push(transaction);
        } else {
            println!("Invalid MultiSigTransaction: insufficient signatures");
        }
    }

    fn mine_pending_transactions(&mut self, mining_reward_address: &str) {
        let reward_transaction = Transaction {
            sender: String::from("0"),
            receiver: mining_reward_address.to_string(),
            amount: self.mining_reward,
            signature: String::new(),
        };
        self.pending_transactions.push(reward_transaction);

        let previous_block = &self.blocks[self.blocks.len() - 1];
        let mut new_block = Block::new(
            self.blocks.len() as u64,
            current_timestamp(),
            self.pending_transactions.clone(),
            &previous_block.hash,
        );
        new_block.mine_block(self.difficulty);
        self.blocks.push(new_block);
        self.pending_transactions.clear();
    }

    fn get_balance_of_address(&self, address: &str) -> u64 {
        let mut balance = 0;
        for block in &self.blocks {
            for transaction in &block.transactions {
                if transaction.sender == address {
                    balance -= transaction.amount;
                }
                if transaction.receiver == address {
                    balance += transaction.amount;
                }
            }
        }
        balance
    }

    fn stake(&mut self, address: String, amount: u64) {
        let entry = self.staking_pool.entry(address).or_insert(0);
        *entry += amount;
    }

    fn select_validator(&self) -> String {
        let mut max_stake = 0;
        let mut validator = String::new();
        for (address, stake) in &self.staking_pool {
            if *stake > max_stake {
                max_stake = *stake;
                validator = address.clone();
            }
        }
        validator
    }

    fn deploy_smart_contract(&mut self, contract: SmartContract) {
        self.smart_contracts.insert(contract.id.clone(), contract);
    }

    fn execute_smart_contract(&mut self, contract_id: &str, data: &str) -> Result<String, String> {
        if let Some(contract) = self.smart_contracts.get_mut(contract_id) {
            Ok(contract.execute(data))
        } else {
            Err("Smart contract not found".to_string())
        }
    }

    fn create_shard(&mut self, shard_id: u64) {
        self.shards.insert(shard_id, Shard { shard_id, blocks: vec![] });
    }

    fn add_block_to_shard(&mut self, shard_id: u64, block: Block) {
        if let Some(shard) = self.shards.get_mut(&shard_id) {
            shard.blocks.push(block);
            println!("Block added to shard with id: {}", shard.shard_id);
        }
    }

    fn register_identity(&mut self, identity: DecentralizedIdentity) {
        self.identities.insert(identity.did.clone(), identity);
    }

    fn verify_identity(&self, did: &str, public_key: &str) -> bool {
        if let Some(identity) = self.identities.get(did) {
            if identity.public_key == public_key {
                println!("Identity verified with attributes: {:?}", identity.attributes);
                true
            } else {
                false
            }
        } else {
            false
        }
    }

    async fn store_data_on_ipfs(&self, data: String) -> Result<String, String> {
        let client = IpfsClient::from_str("http://ipfs.infura.io:5001").unwrap();
        let data = Cursor::new(data);
        match client.add(data).await {
            Ok(res) => Ok(res.hash),
            Err(e) => Err(e.to_string()),
        }
    }
}

fn current_timestamp() -> u128 {
    use std::time::{SystemTime, UNIX_EPOCH};
    let start = SystemTime::now();
    let since_epoch = start.duration_since(UNIX_EPOCH).expect("Time went backwards");
    since_epoch.as_millis()
}

#[tokio::main]
async fn main() {
    let mut blockchain = QuantumFuseBlockchain::new(4, 100);

    // Example usage
    let tx = Transaction {
        sender: "Alice".to_string(),
        receiver: "Bob".to_string(),
        amount: 10,
        signature: "signature".to_string(),
    };
    blockchain.add_transaction(tx.clone());

    let multisig_tx = MultiSigTransaction {
        sender: "Alice".to_string(),
        receivers: vec!["Bob".to_string(), "Charlie".to_string()],
        amount: 20,
        signatures: vec!["signature1".to_string(), "signature2".to_string()],
    };
    blockchain.add_multisig_transaction(multisig_tx);

    blockchain.mine_pending_transactions("miner_address");

    println!("Blockchain: {:?}", blockchain.blocks);

    // Demonstrate using staking and selecting a validator
    blockchain.stake("Alice".to_string(), 50);
    blockchain.stake("Bob".to_string(), 100);
    let validator = blockchain.select_validator();
    println!("Selected validator: {}", validator);

    // Demonstrate deploying and executing a smart contract
    let contract = SmartContract {
        id: "contract1".to_string(),
        code: "code".to_string(),
        owner: "Alice".to_string(),
        state: HashMap::new(),
    };
    blockchain.deploy_smart_contract(contract.clone());
    let execution_result = blockchain.execute_smart_contract(&contract.id, "input data");
    match execution_result {
        Ok(result) => println!("Smart contract execution result: {}", result),
        Err(e) => println!("Smart contract execution failed: {}", e),
    }

    // Demonstrate creating a shard and adding a block to it
    blockchain.create_shard(1);
    let shard_block = Block::new(0, current_timestamp(), vec![tx.clone()], "0");
    blockchain.add_block_to_shard(1, shard_block);
    println!("Shard 1 blocks: {:?}", blockchain.shards.get(&1).unwrap().blocks);

    // Demonstrate registering and verifying a decentralized identity
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

    // Attempt to store data on IPFS
    let result = blockchain.store_data_on_ipfs("Hello, IPFS!".to_string()).await;
    match result {
        Ok(hash) => println!("Stored data on IPFS with hash: {}", hash),
        Err(e) => println!("Failed to store data on IPFS: {}", e),
    }

    // Demonstrate creating a governance proposal and voting
    blockchain.governance.create_proposal(
        "Increase Block Size".to_string(),
        "Proposal to increase the block size to 2MB".to_string(),
        vec!["Yes".to_string(), "No".to_string()],
        current_timestamp() + 10000,
    );
    blockchain.governance.vote(0, "Yes".to_string(), "Alice".to_string());
    blockchain.governance.vote(0, "No".to_string(), "Bob".to_string());
    let results = blockchain.governance.get_results(0);
    println!("Governance proposal results: {:?}", results);

    // Demonstrate fetching balance of an address
    let balance = blockchain.get_balance_of_address("Alice");
    println!("Balance of Alice: {}", balance);
}
