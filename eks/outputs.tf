output "endpoint" {
  value = aws_eks_cluster.k8_retail_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.k8_retail_cluster.certificate_authority[0].data
}
