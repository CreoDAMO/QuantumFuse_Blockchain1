import click
import requests

@click.group()
def cli():
    """QuantumFuse CLI for interacting with the blockchain."""
    pass

@cli.command()
@click.argument('recipient')
@click.argument('amount', type=int)
@click.argument('signature')
@click.option('--sender', default='your_address', help='The sender address for the transaction.')
def create_transaction(recipient, amount, signature, sender):
    """Create a new transaction."""
    url = "http://localhost:5000/transactions/new"
    payload = {"sender": sender, "recipient": recipient, "amount": amount, "signature": signature}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        click.echo(f"Transaction created: {response.json()}")
    except requests.RequestException as e:
        click.echo(f"Error creating transaction: {e}")

@cli.command()
@click.option('--address', default='your_address', help='The address to receive the mining reward.')
def mine_block(address):
    """Mine a new block."""
    url = "http://localhost:5000/mine"
    payload = {"address": address}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        click.echo(f"Block mined: {response.json()}")
    except requests.RequestException as e:
        click.echo(f"Error mining block: {e}")

if __name__ == '__main__':
    cli()
