package main

import (
    "crypto/sha256"
    "encoding/hex"
    "encoding/json"
    "log"
    "net/http"
    "sync"
    "time"

    shell "github.com/ipfs/go-ipfs-api"
)

// Transaction represents a blockchain transaction
type Transaction struct {
    Sender    string `json:"sender"`
    Recipient string `json:"recipient"`
    Amount    uint64 `json:"amount"`
    Signature string `json:"signature"`
}

// Block represents a blockchain block
type Block struct {
    Index        int           `json:"index"`
    Timestamp    int64         `json:"timestamp"`
    Transactions []Transaction `json:"transactions"`
    PreviousHash string        `json:"previous_hash"`
    Hash         string        `json:"hash"`
    Nonce        int           `json:"nonce"`
}

// QuantumFuseBlockchain represents the blockchain
type QuantumFuseBlockchain struct {
    Blocks              []Block       `json:"blocks"`
    PendingTransactions []Transaction `json:"pending_transactions"`
    MiningReward        uint64        `json:"mining_reward"`
}

var blockchain QuantumFuseBlockchain
var mutex = &sync.Mutex{}
var sh *shell.Shell

// calculateHash calculates the SHA-256 hash of a block
func calculateHash(block Block) string {
    record := string(block.Index) + string(block.Timestamp) + block.PreviousHash + string(block.Nonce)
    h := sha256.New()
    h.Write([]byte(record))
    hashed := h.Sum(nil)
    return hex.EncodeToString(hashed)
}

// createBlock creates a new block using the previous block and transactions
func createBlock(previousBlock Block, transactions []Transaction) Block {
    block := Block{
        Index:        previousBlock.Index + 1,
        Timestamp:    time.Now().Unix(),
        Transactions: transactions,
        PreviousHash: previousBlock.Hash,
        Nonce:        0,
    }
    block.Hash = calculateHash(block)
    return block
}

// minePendingTransactions mines the pending transactions and rewards the miner
func minePendingTransactions(miningRewardAddress string) Block {
    rewardTx := Transaction{
        Sender:    "0",
        Recipient: miningRewardAddress,
        Amount:    blockchain.MiningReward,
    }
    blockchain.PendingTransactions = append(blockchain.PendingTransactions, rewardTx)

    previousBlock := blockchain.Blocks[len(blockchain.Blocks)-1]
    newBlock := createBlock(previousBlock, blockchain.PendingTransactions)
    blockchain.Blocks = append(blockchain.Blocks, newBlock)
    blockchain.PendingTransactions = []Transaction{}
    return newBlock
}

// handleGetBlockchain handles the /blockchain endpoint to retrieve the blockchain
func handleGetBlockchain(w http.ResponseWriter, r *http.Request) {
    json.NewEncoder(w).Encode(blockchain)
}

// handleCreateTransaction handles the /transactions/new endpoint to create a new transaction
func handleCreateTransaction(w http.ResponseWriter, r *http.Request) {
    var transaction Transaction
    json.NewDecoder(r.Body).Decode(&transaction)

    mutex.Lock()
    blockchain.PendingTransactions = append(blockchain.PendingTransactions, transaction)
    mutex.Unlock()

    json.NewEncoder(w).Encode(transaction)
}

// handleMineBlock handles the /blocks/mine endpoint to mine a new block
func handleMineBlock(w http.ResponseWriter, r *http.Request) {
    var rewardAddress map[string]string
    json.NewDecoder(r.Body).Decode(&rewardAddress)
    address := rewardAddress["address"]

    mutex.Lock()
    newBlock := minePendingTransactions(address)
    mutex.Unlock()

    json.NewEncoder(w).Encode(newBlock)
}

// handleIPFSAdd handles the /ipfs/add endpoint to add a file to IPFS
func handleIPFSAdd(w http.ResponseWriter, r *http.Request) {
    file, _, err := r.FormFile("file")
    if (err != nil) {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    defer file.Close()

    cid, err := sh.Add(file)
    if (err != nil) {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    w.Write([]byte(cid))
}

func main() {
    sh = shell.NewShell("localhost:5001")

    // Create genesis block
    genesisBlock := Block{Index: 0, Timestamp: time.Now().Unix(), Transactions: []Transaction{}, PreviousHash: "0", Hash: "genesis_block"}
    blockchain = QuantumFuseBlockchain{Blocks: []Block{genesisBlock}, MiningReward: 100}

    http.HandleFunc("/blockchain", handleGetBlockchain)
    http.HandleFunc("/transactions/new", handleCreateTransaction)
    http.HandleFunc("/blocks/mine", handleMineBlock)
    http.HandleFunc("/ipfs/add", handleIPFSAdd)

    log.Fatal(http.ListenAndServe(":8080", nil))
}
