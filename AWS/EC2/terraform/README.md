# Terraform Envs

First export your public and private keys as vars:

```
export TF_VAR_mykey=<path_to_public_key>
export TF_VAR_ssh_key=<path_to_private_key>
```

Navigate to `tf-backend` directory:
```
cd tf-backend
```

Open the `main.tf` file:
```
vi main.tf
```

Comment out this section of the file:

```
terraform {
  backend "s3" {
    bucket         = "demo-terraform-states-backend"
    key            = "tf-backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-terraform-states-backend"
    encrypt        = true
  }
}
```

Then go ahead and save the `main.tf` file and run the following commands:
```
terraform init
terraform apply
```
This will create an S3 bucket where we will store our states and DynamoDB table which we will use to lock the state.

Once this has been done uncomment the `terraform` section in the `main.tf` file and run the command:
```
terraform init
```
This will copy the state to our S3 bucket and the local states can be safely deleted.

- [DEV](https://github.com/prankbox/devops_mentorship/tree/dev/AWS/EC2/terraform/dev)
- [STAGE](https://github.com/prankbox/devops_mentorship/tree/dev/AWS/EC2/terraform/stage)
- [PROD](https://github.com/prankbox/devops_mentorship/tree/dev/AWS/EC2/terraform/prod)
