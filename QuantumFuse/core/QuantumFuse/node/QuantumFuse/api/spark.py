from pyspark.sql import SparkSession
from pyspark.sql.functions import count
from delta.tables import DeltaTable
from kafka import KafkaProducer, KafkaConsumer
import snowflake.connector
from prometheus_client import start_http_server, Summary
import os
from cryptography.fernet import Fernet
import argparse

# Initialize monitoring
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

# Load environment variables
from dotenv import load_dotenv
load_dotenv()

# Encryption key
ENCRYPTION_KEY = os.getenv('ENCRYPTION_KEY')

# Kafka configuration
KAFKA_BROKER = os.getenv('KAFKA_BROKER')
KAFKA_TOPIC = os.getenv('KAFKA_TOPIC')

# Snowflake configuration
SNOWFLAKE_USER = os.getenv('SNOWFLAKE_USER')
SNOWFLAKE_PASSWORD = os.getenv('SNOWFLAKE_PASSWORD')
SNOWFLAKE_ACCOUNT = os.getenv('SNOWFLAKE_ACCOUNT')
SNOWFLAKE_WAREHOUSE = os.getenv('SNOWFLAKE_WAREHOUSE')
SNOWFLAKE_DATABASE = os.getenv('SNOWFLAKE_DATABASE')
SNOWFLAKE_SCHEMA = os.getenv('SNOWFLAKE_SCHEMA')
SNOWFLAKE_TABLE = os.getenv('SNOWFLAKE_TABLE')

# RBAC roles
ROLES = {
    'admin': ['read', 'write', 'execute'],
    'user': ['read'],
    'viewer': ['read']
}

def check_permissions(role, action):
    if action not in ROLES.get(role, []):
        raise PermissionError(f"Role {role} does not have permission to {action}")

def encrypt_data(data):
    cipher_suite = Fernet(ENCRYPTION_KEY)
    return cipher_suite.encrypt(data.encode())

def decrypt_data(data):
    cipher_suite = Fernet(ENCRYPTION_KEY)
    return cipher_suite.decrypt(data).decode()

def load_to_snowflake(dataframe):
    connector = snowflake.connector.connect(
        user=SNOWFLAKE_USER,
        password=SNOWFLAKE_PASSWORD,
        account=SNOWFLAKE_ACCOUNT,
        warehouse=SNOWFLAKE_WAREHOUSE,
        database=SNOWFLAKE_DATABASE,
        schema=SNOWFLAKE_SCHEMA
    )
    try:
        cursor = connector.cursor()
        dataframe.write.format("snowflake").options(
            sfURL=f"{SNOWFLAKE_ACCOUNT}.snowflakecomputing.com",
            sfUser=SNOWFLAKE_USER,
            sfPassword=SNOWFLAKE_PASSWORD,
            sfDatabase=SNOWFLAKE_DATABASE,
            sfSchema=SNOWFLAKE_SCHEMA,
            sfWarehouse=SNOWFLAKE_WAREHOUSE,
            dbtable=SNOWFLAKE_TABLE
        ).save()
        cursor.close()
        connector.close()
    except Exception as e:
        print(f"Error loading data to Snowflake: {e}")

def main(input_path, output_path, role):
    # Check RBAC permissions
    check_permissions(role, 'execute')

    # Initialize Spark session
    spark = SparkSession.builder.appName("BlockchainAnalytics").getOrCreate()

    # Initialize Prometheus monitoring
    start_http_server(8000)

    try:
        # Load blockchain data from the specified input path
        blockchain_data = spark.read.json(input_path)
        
        # Perform analytics to count the number of transactions per block
        transactions_per_block = blockchain_data.groupBy("block_index").agg(count("*").alias("transaction_count"))
        
        # Save the results to Delta Lake
        delta_table_path = os.path.join(output_path, "delta")
        transactions_per_block.write.format("delta").save(delta_table_path)

        # Stream the results to Kafka
        producer = KafkaProducer(bootstrap_servers=KAFKA_BROKER)
        for row in transactions_per_block.collect():
            message = f"Block Index: {row['block_index']}, Transaction Count: {row['transaction_count']}"
            encrypted_message = encrypt_data(message)
            producer.send(KAFKA_TOPIC, encrypted_message)
        producer.flush()
        producer.close()
        
        # Load results to Snowflake
        load_to_snowflake(transactions_per_block)

        print("Analytics results processed and saved successfully.")
    except Exception as e:
        print(f"Error processing blockchain data: {e}")
    finally:
        # Stop the Spark session
        spark.stop()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Blockchain Analytics with Spark")
    parser.add_argument('input_path', type=str, help='Path to the input blockchain data (JSON format)')
    parser.add_argument('output_path', type=str, help='Path to save the analytics results (CSV format)')
    parser.add_argument('--role', type=str, required=True, help='User role for RBAC')
    args = parser.parse_args()
    main(args.input_path, args.output_path, args.role)
