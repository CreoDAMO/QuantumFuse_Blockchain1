package main

import (
    "crypto/sha256"
    "encoding/hex"
    "encoding/json"
    "fmt"
    "log"
    "net/http"
    "strconv"
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
    record := strconv.Itoa(block.Index) + strconv.FormatInt(block.Timestamp, 10) + block.PreviousHash + strconv.Itoa(block.Nonce)
    for _, tx := range block.Transactions {
        record += tx.Sender + tx.Recipient + strconv.FormatUint(tx.Amount, 10) + tx.Signature
    }
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
    }
    block.Hash = calculateHash(block)
    return block
}

// proofOfWork performs a basic proof-of-work by finding a valid nonce
func proofOfWork(block Block, difficulty int) Block {
    target := fmt.Sprintf("%0*s", difficulty, "0")
    for !isValidHash(block.Hash, target) {
        block.Nonce++
        block.Hash = calculateHash(block)
    }
    return block
}

// isValidHash checks if the hash meets the difficulty target
func isValidHash(hash, target string) bool {
    return hash[:len(target)] == target
}

// minePendingTransactions mines the pending transactions and rewards the miner
func minePendingTransactions(miningRewardAddress string, difficulty int) Block {
    rewardTx := Transaction{
        Sender:    "0",
        Recipient: miningRewardAddress,
        Amount:    blockchain.MiningReward,
    }
    blockchain.PendingTransactions = append(blockchain.PendingTransactions, rewardTx)

    previousBlock := blockchain.Blocks[len(blockchain.Blocks)-1]
    newBlock := createBlock(previousBlock, blockchain.PendingTransactions)
    newBlock = proofOfWork(newBlock, difficulty)
    
    mutex.Lock()
    blockchain.Blocks = append(blockchain.Blocks, newBlock)
    blockchain.PendingTransactions = []Transaction{}
    mutex.Unlock()
    
    return newBlock
}

// handleGetBlockchain handles the /blockchain endpoint to retrieve the blockchain
func handleGetBlockchain(w http.ResponseWriter, r *http.Request) {
    mutex.Lock()
    defer mutex.Unlock()
    
    json.NewEncoder(w).Encode(blockchain)
}

// handleCreateTransaction handles the /transactions/new endpoint to create a new transaction
func handleCreateTransaction(w http.ResponseWriter, r *http.Request) {
    var transaction Transaction
    if err := json.NewDecoder(r.Body).Decode(&transaction); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    mutex.Lock()
    blockchain.PendingTransactions = append(blockchain.PendingTransactions, transaction)
    mutex.Unlock()

    json.NewEncoder(w).Encode(transaction)
}

// handleMineBlock handles the /blocks/mine endpoint to mine a new block
func handleMineBlock(w http.ResponseWriter, r *http.Request) {
    var rewardAddress map[string]string
    if err := json.NewDecoder(r.Body).Decode(&rewardAddress); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    address := rewardAddress["address"]

    newBlock := minePendingTransactions(address, 4)

    json.NewEncoder(w).Encode(newBlock)
}

// handleIPFSAdd handles the /ipfs/add endpoint to add a file to IPFS
func handleIPFSAdd(w http.ResponseWriter, r *http.Request) {
    file, _, err := r.FormFile("file")
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    defer file.Close()

    cid, err := sh.Add(file)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    w.Write([]byte(cid))
}

func main() {
    sh = shell.NewShell("localhost:5001")

    // Create genesis block
    genesisBlock := Block{
        Index:        0,
        Timestamp:    time.Now().Unix(),
        Transactions: []Transaction{},
        PreviousHash: "0",
        Hash:         "genesis_block",
    }
    genesisBlock.Hash = calculateHash(genesisBlock)
    
    blockchain = QuantumFuseBlockchain{
        Blocks:        []Block{genesisBlock},
        MiningReward:  100,
    }

    http.HandleFunc("/blockchain", handleGetBlockchain)
    http.HandleFunc("/transactions/new", handleCreateTransaction)
    http.HandleFunc("/blocks/mine", handleMineBlock)
    http.HandleFunc("/ipfs/add", handleIPFSAdd)

    log.Fatal(http.ListenAndServe(":8080", nil))
}
