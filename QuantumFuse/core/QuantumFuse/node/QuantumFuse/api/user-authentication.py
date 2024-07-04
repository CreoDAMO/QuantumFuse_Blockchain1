from flask import Flask, jsonify, request, make_response
import jwt
import datetime
from functools import wraps
import logging
import os
from dotenv import load_dotenv
import requests

# Load environment variables from .env file
load_dotenv()

# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'your_default_secret_key')
blockchain_url = os.getenv('BLOCKCHAIN_URL', 'http://localhost:8080')

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('x-access-tokens')
        if not token:
            logger.warning("Token is missing")
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
        try:
            token = jwt.encode(
                {'user': auth.username, 'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},
                app.config['SECRET_KEY'],
                algorithm="HS256"
            )
            logger.info(f"User {auth.username} logged in and token generated")
            return jsonify({'token': token})
        except Exception as e:
            logger.error(f"Error generating token: {e}")
            return jsonify({'message': 'Error generating token'}), 500
    logger.warning("Invalid login attempt")
    return make_response('Could not verify', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})

@app.route('/transactions/new', methods=['POST'])
@token_required
def new_transaction():
    values = request.get_json()
    required = ['sender', 'recipient', 'amount', 'signature']
    if not all(k in values for k in required):
        logger.warning("Transaction request missing values")
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

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
