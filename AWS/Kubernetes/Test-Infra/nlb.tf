module "aws-nlb" {
  source = "./modules/nlb"

  aws_cluster_name      = var.aws_cluster_name
  aws_vpc_id            = module.aws-vpc.aws_vpc_id
  aws_avail_zones       = data.aws_availability_zones.available.names
  aws_subnet_ids_public = module.aws-vpc.aws_subnet_ids_public
  aws_nlb_api_port      = var.aws_nlb_api_port
  k8s_secure_api_port   = var.k8s_secure_api_port
  default_tags          = var.default_tags
}

resource "aws_lb_target_group_attachment" "tg-attach_master_nodes" {
  count            = var.aws_kube_master_num
  target_group_arn = module.aws-nlb.aws_nlb_api_tg_arn
  target_id        = element(aws_instance.k8s-master.*.private_ip, count.index)
}