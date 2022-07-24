output "url_identity" {
    value = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}

output "openid" {
    value = aws_iam_openid_connect_provider.eks.arn
}