from flask import Flask, jsonify, request, make_response
import requests
import ipfshttpclient
from prometheus_client import start_http_server, Summary
import jwt
import datetime
from functools import wraps

# Initialize monitoring
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

app = Flask(__name__)
blockchain_url = "http://localhost:8080"
ipfs = ipfshttpclient.connect()
app.config['SECRET_KEY'] = 'your_secret_key'

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('x-access-tokens')
        if not token:
            return jsonify({'message': 'Token is missing'}), 403
        try:
            data = jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])
        except jwt.ExpiredSignatureError:
            return jsonify({'message': 'Token has expired'}), 403
        except jwt.InvalidTokenError:
            return jsonify({'message': 'Token is invalid'}), 403
        return f(*args, **kwargs)
    return decorated

@app.route('/login', methods=['POST'])
def login():
    auth = request.authorization
    if auth and auth.password == 'password':
        token = jwt.encode({'user': auth.username, 'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)}, app.config['SECRET_KEY'], algorithm="HS256")
        return jsonify({'token': token})
    return make_response('Could not verify', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})

@app.route('/transactions/new', methods=['POST'])
@REQUEST_TIME.time()
@token_required
def new_transaction():
    values = request.get_json()
    required = ['sender', 'recipient', 'amount', 'signature']
    if not all(k in values for k in required):
        return jsonify({'message': 'Missing values'}), 400

    transaction = {
        "sender": values['sender'],
        "recipient": values['recipient'],
        "amount": values['amount'],
        "signature": values['signature']
    }

    response = requests.post(f"{blockchain_url}/transactions/new", json=transaction)
    return jsonify(response.json()), response.status_code

@app.route('/chain', methods=['GET'])
def full_chain():
    response = requests.get(f"{blockchain_url}/blockchain")
    return jsonify(response.json()), response.status_code

@app.route('/mine', methods=['POST'])
@token_required
def mine_block():
    values = request.get_json()
    address = values.get('address')
    if not address:
        return jsonify({'message': 'Missing address'}), 400

    response = requests.post(f"{blockchain_url}/blocks/mine", json={"address": address})
    return jsonify(response.json()), response.status_code

@app.route('/ipfs/add', methods=['POST'])
@token_required
def add_to_ipfs():
    if 'file' not in request.files:
        return jsonify({'message': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'message': 'No selected file'}), 400
    res = ipfs.add(file)
    return jsonify(res), 200

if __name__ == '__main__':
    start_http_server(8000)
    app.run(host='0.0.0.0', port=5000)
