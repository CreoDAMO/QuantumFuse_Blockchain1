import hashlib
import time
import json
import requests
from collections import defaultdict

class Transaction:
    def __init__(self, sender, receiver, amount, signature):
        self.sender = sender
        self.receiver = receiver
        self.amount = amount
        self.signature = signature

    def to_dict(self):
        return {
            "sender": self.sender,
            "receiver": self.receiver,
            "amount": self.amount,
            "signature": self.signature,
        }

class MultiSigTransaction:
    def __init__(self, sender, receivers, amount, signatures):
        self.sender = sender
        self.receivers = receivers
        self.amount = amount
        self.signatures = signatures

    def is_valid(self):
        return len(self.signatures) >= len(self.receivers) // 2 + 1

    def to_dict(self):
        return {
            "sender": self.sender,
            "receivers": self.receivers,
            "amount": self.amount,
            "signatures": self.signatures,
        }

class Block:
    def __init__(self, index, timestamp, transactions, previous_hash):
        self.index = index
        self.timestamp = timestamp
        self.transactions = transactions
        self.previous_hash = previous_hash
        self.nonce = 0
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        block_data = json.dumps(self.__dict__, sort_keys=True).encode()
        return hashlib.sha256(block_data).hexdigest()

    def mine_block(self, difficulty):
        target = "0" * difficulty
        while self.hash[:difficulty] != target:
            self.nonce += 1
            self.hash = self.calculate_hash()

class QuantumFuseBlockchain:
    def __init__(self, difficulty, mining_reward):
        self.blocks = []
        self.difficulty = difficulty
        self.pending_transactions = []
        self.multisig_transactions = []
        self.mining_reward = mining_reward
        self.staking_pool = defaultdict(int)
        genesis_block = Block(0, int(time.time()), [], "0")
        self.blocks.append(genesis_block)

    def add_transaction(self, transaction):
        self.pending_transactions.append(transaction)

    def add_multisig_transaction(self, transaction):
        if transaction.is_valid():
            self.multisig_transactions.append(transaction)

    def mine_pending_transactions(self, mining_reward_address):
        reward_transaction = Transaction("0", mining_reward_address, self.mining_reward, "")
        self.pending_transactions.append(reward_transaction)
        last_block = self.blocks[-1]
        new_block = Block(len(self.blocks), int(time.time()), [tx.to_dict() for tx in self.pending_transactions], last_block.hash)
        new_block.mine_block(self.difficulty)
        self.blocks.append(new_block)
        self.pending_transactions = []

    def get_balance_of_address(self, address):
        balance = 0
        for block in self.blocks:
            for tx in block.transactions:
                if tx['sender'] == address:
                    balance -= tx['amount']
                if tx['receiver'] == address:
                    balance += tx['amount']
        return balance

    def stake(self, address, amount):
        self.staking_pool[address] += amount

    def select_validator(self):
        return max(self.staking_pool, key=self.staking_pool.get, default="")

    def store_data_on_ipfs(self, data):
        url = "http://localhost:5001/api/v0/add"
        files = {'file': ('data.txt', data)}
        response = requests.post(url, files=files)
        return response.json().get('Hash')

# Example usage
blockchain = QuantumFuseBlockchain(4, 100)
tx = Transaction("Alice", "Bob", 10, "signature")
blockchain.add_transaction(tx)

blockchain.mine_pending_transactions("miner_address")

print("Blockchain:", [block.__dict__ for block in blockchain.blocks])

result = blockchain.store_data_on_ipfs("Hello, IPFS!")


print("Stored data on IPFS with hash:", result)
