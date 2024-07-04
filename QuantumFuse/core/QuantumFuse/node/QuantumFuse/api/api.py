from flask import Flask, jsonify, request, make_response
import requests
import ipfshttpclient
from prometheus_client import start_http_server, Summary
import jwt
import datetime
from functools import wraps
import logging
import os
from dotenv import load_dotenv
from plaid import Client as PlaidClient
from coinbase.wallet.client import Client as CoinbaseClient
from coinmarketcap import Market as CoinMarketCapMarket

# Load environment variables
load_dotenv()

# Initialize monitoring
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

# Setup Flask app
app = Flask(__name__)
blockchain_url = "http://localhost:8080"
ipfs = ipfshttpclient.connect()
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Plaid Client
plaid_client = PlaidClient(client_id=os.getenv('PLAID_CLIENT_ID'),
                           secret=os.getenv('PLAID_SECRET'),
                           environment=os.getenv('PLAID_ENV', 'sandbox'))

# Coinbase Client
coinbase_client = CoinbaseClient(api_key=os.getenv('COINBASE_API_KEY'),
                                 api_secret=os.getenv('COINBASE_API_SECRET'))

# CoinMarketCap Client
coinmarketcap_client = CoinMarketCapMarket(api_key=os.getenv('COINMARKETCAP_API_KEY'))

# Authentication decorator
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('x-access-tokens')
        if not token:
            return jsonify({'message': 'Token is missing'}), 403
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
            logger.info(f"Token verified for user: {data['user']}")
        except jwt.ExpiredSignatureError:
            logger.warning("Token has expired")
            return jsonify({'message': 'Token has expired'}), 403
        except jwt.InvalidTokenError:
            logger.warning("Token is invalid")
            return jsonify({'message': 'Token is invalid'}), 403
        return f(*args, **kwargs)
    return decorated

@app.route('/login', methods=['POST'])
def login():
    auth = request.authorization
    if auth and auth.password == 'password':
        token = jwt.encode({'user': auth.username, 'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)}, app.config['SECRET_KEY'], algorithm="HS256")
        logger.info(f"User {auth.username} logged in")
        return jsonify({'token': token})
    logger.warning("Invalid login attempt")
    return make_response('Could not verify', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})

@app.route('/transactions/new', methods=['POST'])
@REQUEST_TIME.time()
@token_required
def new_transaction():
    values = request.get_json()
    required = ['sender', 'recipient', 'amount', 'signature']
    if not all(k in values for k in required):
        logger.error("Transaction request missing values")
        return jsonify({'message': 'Missing values'}), 400

    transaction = {
        "sender": values['sender'],
        "recipient": values['recipient'],
        "amount": values['amount'],
        "signature": values['signature']
    }

    try:
        response = requests.post(f"{blockchain_url}/transactions/new", json=transaction)
        response.raise_for_status()
        logger.info("Transaction successfully created")
        return jsonify(response.json()), response.status_code
    except requests.RequestException as e:
        logger.error(f"Error creating transaction: {e}")
        return jsonify({'message': 'Failed to create transaction'}), 500

@app.route('/chain', methods=['GET'])
@REQUEST_TIME.time()
def full_chain():
    try:
        response = requests.get(f"{blockchain_url}/blockchain")
        response.raise_for_status()
        logger.info("Fetched full blockchain")
        return jsonify(response.json()), response.status_code
    except requests.RequestException as e:
        logger.error(f"Error fetching blockchain: {e}")
        return jsonify({'message': 'Failed to fetch blockchain'}), 500

@app.route('/mine', methods=['POST'])
@REQUEST_TIME.time()
@token_required
def mine_block():
    values = request.get_json()
    address = values.get('address')
    if not address:
        logger.error("Mining request missing address")
        return jsonify({'message': 'Missing address'}), 400

    try:
        response = requests.post(f"{blockchain_url}/blocks/mine", json={"address": address})
        response.raise_for_status()
        logger.info(f"Block mined successfully for address {address}")
        return jsonify(response.json()), response.status_code
    except requests.RequestException as e:
        logger.error(f"Error mining block: {e}")
        return jsonify({'message': 'Failed to mine block'}), 500

@app.route('/ipfs/add', methods=['POST'])
@REQUEST_TIME.time()
@token_required
def add_to_ipfs():
    if 'file' not in request.files:
        logger.error("IPFS add request missing file part")
        return jsonify({'message': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        logger.error("IPFS add request missing selected file")
        return jsonify({'message': 'No selected file'}), 400
    try:
        res = ipfs.add(file)
        logger.info(f"File added to IPFS with hash {res['Hash']}")
        return jsonify(res), 200
    except Exception as e:
        logger.error(f"Error adding file to IPFS: {e}")
        return jsonify({'message': 'Failed to add file to IPFS'}), 500

@app.route('/plaid/accounts', methods=['GET'])
@token_required
def get_plaid_accounts():
    try:
        response = plaid_client.Accounts.get(access_token=os.getenv('PLAID_ACCESS_TOKEN'))
        logger.info("Fetched Plaid accounts")
        return jsonify(response), 200
    except Exception as e:
        logger.error(f"Error fetching Plaid accounts: {e}")
        return jsonify({'message': 'Failed to fetch Plaid accounts'}), 500

@app.route('/coinbase/balance', methods=['GET'])
@token_required
def get_coinbase_balance():
    try:
        accounts = coinbase_client.get_accounts()
        logger.info("Fetched Coinbase balance")
        return jsonify(accounts), 200
    except Exception as e:
        logger.error(f"Error fetching Coinbase balance: {e}")
        return jsonify({'message': 'Failed to fetch Coinbase balance'}), 500

@app.route('/coinmarketcap/price', methods=['GET'])
@token_required
def get_coinmarketcap_price():
    symbol = request.args.get('symbol')
    if not symbol:
        return jsonify({'message': 'Missing symbol'}), 400
    try:
        price = coinmarketcap_client.ticker(symbol)
        logger.info(f"Fetched CoinMarketCap price for {symbol}")
        return jsonify(price), 200
    except Exception as e:
        logger.error(f"Error fetching CoinMarketCap price: {e}")
        return jsonify({'message': 'Failed to fetch CoinMarketCap price'}), 500

@app.route('/sec/company/<cik>', methods=['GET'])
@token_required
def get_sec_company(cik):
    url = f"https://data.sec.gov/submissions/CIK{cik}.json"
    headers = {'User-Agent': 'YourAppName/0.1'}
    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        logger.info(f"Fetched SEC data for CIK {cik}")
        return jsonify(response.json()), 200
    except requests.RequestException as e:
        logger.error(f"Error fetching SEC data: {e}")
        return jsonify({'message': 'Failed to fetch SEC data'}), 500

@app.route('/irs/tax-exempt/<ein>', methods=['GET'])
@token_required
def get_irs_tax_exempt(ein):
    url = f"https://apps.irs.gov/app/eos/api/ein/{ein}"
    try:
        response = requests.get(url)
        response.raise_for_status()
        logger.info(f"Fetched IRS tax-exempt data for EIN {ein}")
        return jsonify(response.json()), 200
    except requests.RequestException as e:
        logger.error(f"Error fetching IRS tax-exempt data: {e}")
        return jsonify({'message': 'Failed to fetch IRS tax-exempt data'}), 500

@app.route('/usdc/price', methods=['GET'])
@token_required
def get_usdc_price():
    url = "https://api.coinbase.com/v2/prices/USDC-USD/spot"
    try:
        response = requests.get(url)
        response.raise_for_status()
        price = response.json()['data']['amount']
        logger.info("Fetched USDC price")
        return jsonify({'price': price}), 200
    except requests.RequestException as e:
        logger.error(f"Error fetching USDC price: {e}")
        return jsonify({'message': 'Failed to fetch USDC price'}), 500

if __name__ == '__main__':
    start_http_server(8000)
    app.run(host='0.0.0.0', port=5000)
