output "endpoint" {
  value = aws_eks_cluster.k8_weather_app.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.k8_weather_app.certificate_authority[0].data
}
