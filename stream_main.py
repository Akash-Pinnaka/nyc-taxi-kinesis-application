import boto3
import json
import dateutil.parser as parser
from time import sleep
from datetime import datetime
import pandas as pd
import pyarrow.parquet as pq
from io import BytesIO

# AWS Settings
s3 = boto3.client('s3', region_name='us-east-1')
s3_resource = boto3.resource('s3', region_name='us-east-1')
kinesis_client = boto3.client('kinesis', region_name='us-east-1')

# Env. variables; i.e. can be OS variables in Lambda
kinesis_stream_name = 'nyc-taxi-tf'
streaming_partition_key = 'DOLocationID'


def stream_data_simulator(input_s3_bucket, input_s3_key):
    s3_bucket = input_s3_bucket
    s3_key = input_s3_key

    # Read Parquet file from S3
    parquet_obj = s3_resource.Object(s3_bucket, s3_key)
    s3_response = parquet_obj.get()
    parquet_data = s3_response['Body'].read()

 

    # Convert the Parquet data to a Pandas DataFrame

    table = pq.read_table(BytesIO(parquet_data))
 
    df = table.to_pandas()



    for index, row in df.iloc[:100].iterrows():
        try:
            row_dict = row.to_dict()

            # Convert Timestamps to ISO format strings
            for key in row_dict:
                if isinstance(row_dict[key], pd.Timestamp):
                    row_dict[key] = row_dict[key].isoformat()

            line_json = json.dumps(row_dict)
            json_load = json.loads(line_json)

           
            json_load['Txn_Timestamp'] = datetime.now().isoformat()

            # Write to Kinesis Streams:
            response = kinesis_client.put_record(
                StreamName=kinesis_stream_name,
                Data=json.dumps(json_load, indent=4),
                PartitionKey=str(json_load[streaming_partition_key])
            )
            print(response)

        except Exception as e:
            print('Error: {}'.format(e))

# Run stream:
for i in range(0, 1):
    stream_data_simulator(input_s3_bucket="taxi-nyx-kinesis-akash-7", input_s3_key="yellow_tripdata_2024-01.parquet")