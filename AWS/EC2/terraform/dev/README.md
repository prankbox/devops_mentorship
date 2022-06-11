# Terraform Dev

First export your public and private keys as vars:

```
export TF_VAR_mykey=<path_to_public_key>
export TF_VAR_ssh_key=<path_to_private_key>
```
Then go ahead and to deploy your infrustructure:

```
terraform init
terraform plan
terraform apply
```

Whenever you wanto to destroy your infra, run the command:
```
terraform destroy
```
