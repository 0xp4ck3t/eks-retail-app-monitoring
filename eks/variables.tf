# --- iam/variables.tf ---

variable "public_sn" {
}
variable "eks_role" {}
variable "AmazonEKSClusterPolicy" {}
variable "K8-AmazonEKSVPCResourceController" {}
variable "k8_version" {}
variable "AWS_EKS_VPC_CNI_Role" {}
variable "AmazonEC2ContainerRegistryReadOnly" {}
variable "AmazonEKS_CNI_Policy" {}
variable "AmazonEKSWorkerNodePolicy" {}
variable "Worker_Node_Role" {}