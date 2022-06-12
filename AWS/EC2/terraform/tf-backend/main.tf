terraform {
  backend "s3" {
    bucket         = "demo-terraform-states-backend"
    key            = "tf-backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-terraform-states-backend"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "TerminationDate"  = "Permanent",
      "Environment"      = "Development",
      "Team"             = "DevOps",
      "DeployedBy"       = "Terraform",
      "OwnerEmail"       = "sergey@example.com"
      
    }
  }
}

module "tf_backend" {
  source              = "../modules/tf-backend/"
  s3_bucket_name      = "demo-terraform-states-backend"
  dynamodb_table_name = "demo-terraform-states-backend"
}