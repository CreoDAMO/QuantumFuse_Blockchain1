from pyspark.sql import SparkSession
from pyspark.sql.functions import count

def main(input_path, output_path):
    # Initialize Spark session
    spark = SparkSession.builder.appName("BlockchainAnalytics").getOrCreate()

    try:
        # Load blockchain data from the specified input path
        blockchain_data = spark.read.json(input_path)
        
        # Perform analytics to count the number of transactions per block
        transactions_per_block = blockchain_data.groupBy("block_index").agg(count("*").alias("transaction_count"))
        
        # Save the results to the specified output path
        transactions_per_block.write.csv(output_path)
        
        print("Analytics results saved successfully.")
    except Exception as e:
        print(f"Error processing blockchain data: {e}")
    finally:
        # Stop the Spark session
        spark.stop()

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Blockchain Analytics with Spark")
    parser.add_argument('input_path', type=str, help='Path to the input blockchain data (JSON format)')
    parser.add_argument('output_path', type=str, help='Path to save the analytics results (CSV format)')
    args = parser.parse_args()
    main(args.input_path, args.output_path)
