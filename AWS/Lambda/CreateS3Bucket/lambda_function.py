import boto3
import os
import time

bucketname = "prankbucket-" + str(time.time())

def lambda_handler(event, context):
	mys3 = boto3.client('s3')
	try:
		print(f'Trying to create {bucketname}...')
		result = mys3.create_bucket(Bucket=bucketname)
		print(f'The result is {result}')
		return ("Bucket " +str(result) + "has been created")
	except:
		return "No shit you have your bucket"