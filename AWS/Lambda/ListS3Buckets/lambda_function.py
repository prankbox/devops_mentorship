import boto3
		
def lambda_handler(event, context):
	s3 = boto3.client('s3')
	response = s3.list_buckets()
	
	buckets = []
	print('Existing buckets:')
	for bucket in response['Buckets']:
		print(f'  {bucket["Name"]}')
		buckets.append(bucket["Name"])
		
	return buckets