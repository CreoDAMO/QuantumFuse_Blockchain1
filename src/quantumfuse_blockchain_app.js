import React, { useEffect, useState, useCallback } from 'react';
import { w3cwebsocket as W3CWebSocket } from 'websocket';
import { Line, Bar } from 'react-chartjs-2';
import debounce from 'lodash.debounce';

const client = new W3CWebSocket('wss://api.quantumfuse.com/v2/realtime');

function QuantumFuseApp() {
  const [blocks, setBlocks] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [filteredBlocks, setFilteredBlocks] = useState([]);
  const [chartData, setChartData] = useState({});
  const [transactionData, setTransactionData] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    client.onopen = () => {
      console.log('WebSocket Client Connected');
      setLoading(false);
    };

    client.onerror = (err) => {
      console.error('WebSocket error:', err);
      setError('WebSocket connection error');
      setLoading(false);
    };

    client.onmessage = (message) => {
      const block = JSON.parse(message.data);
      setBlocks((prevBlocks) => [block, ...prevBlocks]);
    };

    return () => {
      client.close();
    };
  }, []);

  useEffect(() => {
    if (blocks.length === 0) return;

    const blockIndexes = blocks.map((block) => block.index);
    const blockTimestamps = blocks.map((block) => new Date(block.timestamp));
    setChartData({
      labels: blockTimestamps,
      datasets: [
        {
          label: 'Block Index',
          data: blockIndexes,
          fill: false,
          borderColor: 'rgb(75, 192, 192)',
          tension: 0.1,
        },
      ],
    });

    const transactions = blocks.flatMap((block) => block.transactions);
    const transactionAmounts = transactions.map((tx) => tx.amount);
    setTransactionData({
      labels: transactions.map((tx) => tx.sender),
      datasets: [
        {
          label: 'Transaction Amount',
          data: transactionAmounts,
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1,
        },
      ],
    });
  }, [blocks]);

  useEffect(() => {
    setFilteredBlocks(
      blocks.filter((block) =>
        block.transactions.some(
          (transaction) =>
            transaction.sender.includes(searchTerm) || transaction.recipient.includes(searchTerm)
        )
      )
    );
  }, [blocks, searchTerm]);

  const handleSearch = useCallback(
    debounce((value) => {
      setSearchTerm(value);
    }, 300),
    []
  );

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }

  return (
    <div>
      <h1>QuantumFuse Explorer</h1>
      <div>
        <h2>Real-Time Blockchain Blocks</h2>
        <ul>
          {blocks.map((block) => (
            <li key={block.index}>
              Block {block.index} - Timestamp: {new Date(block.timestamp).toLocaleString()}
            </li>
          ))}
        </ul>
      </div>
      <div>
        <h2>Search Transactions</h2>
        <input
          type="text"
          onChange={(e) => handleSearch(e.target.value)}
          placeholder="Search by sender or recipient..."
        />
        <ul>
          {filteredBlocks.map((block) => (
            <li key={block.index}>
              Block {block.index} - Timestamp: {new Date(block.timestamp).toLocaleString()}
              <ul>
                {block.transactions.map((transaction, idx) => (
                  <li key={idx}>
                    Sender: {transaction.sender}, Recipient: {transaction.recipient}, Amount: {transaction.amount}
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      </div>
      <div>
        <h2>Blockchain Chart</h2>
        <Line data={chartData} />
      </div>
      <div>
        <h2>Transaction Data</h2>
        <Bar data={transactionData} />
      </div>
    </div>
  );
}

export default QuantumFuseApp;
