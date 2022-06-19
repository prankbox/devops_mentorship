import boto3
import os
import time

AWS_DEFAULT_REGION = 'us-east-1'
os.environ['AWS_DEFAULT_REGION'] = AWS_DEFAULT_REGION
bucketname = "prankbucket-" + str(time.time())

def lambda_handler(event, context):
	mys3 = boto3.client('s3',region_name=AWS_DEFAULT_REGION)
	try:
		print(f'Trying to create {bucketname}...')
		result = mys3.create_bucket(Bucket=bucketname, CreateBucketConfiguration={'LocationConstraint':AWS_DEFAULT_REGION})
		print(f'The result is {result}')
		return ("Bucket " +str(result) + "has been created")
	except:
		return "No shit you have your bucket"