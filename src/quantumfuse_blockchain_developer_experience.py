import click
import requests

@click.group()
def cli():
    pass

@cli.command()
@click.argument('recipient')
@click.argument('amount')
@click.argument('signature')
def create_transaction(recipient, amount, signature):
    url = "http://localhost:5000/transactions/new"
    payload = {"sender": "your_address", "recipient": recipient, "amount": amount, "signature": signature}
    response = requests.post(url, json=payload)
    click.echo(response.text)

@cli.command()
def mine_block():
    url = "http://localhost:5000/mine"
    payload = {"address": "your_address"}
    response = requests.post(url, json=payload)
    click.echo(response.text)

if __name__ == '__main__':
    cli()
