module "aws-iam" {
  source = "./modules/iam"

  aws_cluster_name = var.aws_cluster_name
}