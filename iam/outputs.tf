# --- iam/outputs.tf ---

output "eks_role" {
  value = aws_iam_role.AWS_EKS_Role.arn
}

output "AmazonEKSClusterPolicy" {
  value = aws_iam_role_policy_attachment.AmazonEKSClusterPolicy
}

output "K8-AmazonEKSVPCResourceController" {
  value = aws_iam_role_policy_attachment.K8-AmazonEKSVPCResourceController
}

output "AWS_CNI_Role" {
  value = aws_iam_role.AWS_EKS_VPC_CNI_Role.arn
}

output "AmazonEKS_CNI_Policy" {
  value = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
}

output "AmazonEC2ContainerRegistryReadOnly" {
  value = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
}

output "AmazonEKSWorkerNodePolicy" {
  value = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy
}

output "Worker_Node_Role" {
  value = aws_iam_role.AWS_EKS_Worker_Node_Role.arn
}