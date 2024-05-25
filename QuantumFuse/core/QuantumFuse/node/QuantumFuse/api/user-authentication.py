from flask import Flask, jsonify, request, make_response
import jwt
import datetime
from functools import wraps
import logging

# Initialize logging
logging.basicConfig(level=logging.ERROR)
logger = logging.getLogger(__name__)

app = Flask(__name__)
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
        try:
            token = jwt.encode(
                {'user': auth.username, 'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},
                app.config['SECRET_KEY'],
                algorithm="HS256"
            )
            return jsonify({'token': token})
        except Exception as e:
            logger.error(f"Error generating token: {e}")
            return jsonify({'message': 'Error generating token'}), 500
    return make_response('Could not verify', 401, {'WWW-Authenticate': 'Basic realm="Login required!"'})

@app.route('/transactions/new', methods=['POST'])
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

    # Assuming the blockchain_url is defined elsewhere in the code
    response = requests.post(f"{blockchain_url}/transactions/new", json=transaction)
    return jsonify(response.json()), response.status_code

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
