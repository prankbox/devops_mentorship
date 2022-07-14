resource "aws_instance" "bastion-server" {
  ami                         = data.aws_ami.distro.id
  instance_type               = var.aws_bastion_size
  count                       = var.aws_bastion_num
  associate_public_ip_address = true
  subnet_id                   = element(module.aws-vpc.aws_subnet_ids_public, count.index)

  vpc_security_group_ids = module.aws-vpc.aws_security_group

  key_name = aws_key_pair.ssh_key.key_name

  tags = merge(var.default_tags, tomap({
    Name    = "kubernetes-${var.aws_cluster_name}-bastion-${count.index}"
    Cluster = var.aws_cluster_name
    Role    = "bastion-${var.aws_cluster_name}-${count.index}"
  }))
}

/*
* Create K8s Master and worker nodes and etcd instances
*
*/

resource "aws_instance" "k8s-master" {
  ami           = data.aws_ami.distro.id
  instance_type = var.aws_kube_master_size

  count = var.aws_kube_master_num

  subnet_id = element(module.aws-vpc.aws_subnet_ids_private, count.index)

  vpc_security_group_ids = module.aws-vpc.aws_security_group

  root_block_device {
    volume_size = var.aws_kube_master_disk_size
  }

  iam_instance_profile = module.aws-iam.kube_control_plane-profile
  key_name             = aws_key_pair.ssh_key.key_name

  tags = merge(var.default_tags, tomap({
    Name                                            = "kubernetes-${var.aws_cluster_name}-master${count.index}"
    "kubernetes.io/cluster/${var.aws_cluster_name}" = "member"
    Role                                            = "master"
  }))
}



resource "aws_instance" "k8s-etcd" {
  ami           = data.aws_ami.distro.id
  instance_type = var.aws_etcd_size

  count = var.aws_etcd_num

  subnet_id = element(module.aws-vpc.aws_subnet_ids_private, count.index)

  vpc_security_group_ids = module.aws-vpc.aws_security_group

  root_block_device {
    volume_size = var.aws_etcd_disk_size
  }

  key_name = aws_key_pair.ssh_key.key_name

  tags = merge(var.default_tags, tomap({
    Name                                            = "kubernetes-${var.aws_cluster_name}-etcd${count.index}"
    "kubernetes.io/cluster/${var.aws_cluster_name}" = "member"
    Role                                            = "etcd"
  }))
}

resource "aws_instance" "k8s-worker" {
  ami           = data.aws_ami.distro.id
  instance_type = var.aws_kube_worker_size

  count = var.aws_kube_worker_num

  subnet_id = element(module.aws-vpc.aws_subnet_ids_private, count.index)

  vpc_security_group_ids = module.aws-vpc.aws_security_group

  root_block_device {
    volume_size = var.aws_kube_worker_disk_size
  }

  iam_instance_profile = module.aws-iam.kube-worker-profile
  key_name             = aws_key_pair.ssh_key.key_name

  tags = merge(var.default_tags, tomap({
    Name                                            = "kubernetes-${var.aws_cluster_name}-worker${count.index}"
    "kubernetes.io/cluster/${var.aws_cluster_name}" = "member"
    Role                                            = "worker"
  }))
}