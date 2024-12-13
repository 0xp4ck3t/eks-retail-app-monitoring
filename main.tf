# --- root/main.tf ---

module "network" {
  source           = "./network"
  vpc_cidr         = local.vpc_cidr
  private_sn_count = 2
  public_sn_count  = 2
  access_ip        = var.access_ip
  https_security_groups  = local.https_security_groups
  ssh_security_groups = local.ssh_security_groups
  alb_security_groups = local.ALB_security_groups
}

module "iam" {
  source = "./iam"
}
module "eks" {
  source = "./eks"
  private_sn = module.network.private_subnets
  eks_role = module.iam.eks_role
  AmazonEKSClusterPolicy = module.iam.AmazonEKSClusterPolicy
  K8-AmazonEKSVPCResourceController = module.iam.K8-AmazonEKSVPCResourceController
  k8_version = 1.31
  AWS_EKS_VPC_CNI_Role = module.iam.AWS_CNI_Role
  AmazonEC2ContainerRegistryReadOnly = module.iam.AmazonEC2ContainerRegistryReadOnly
  AmazonEKS_CNI_Policy = module.iam.AmazonEKS_CNI_Policy
  AmazonEKSWorkerNodePolicy = module.iam.AmazonEKSWorkerNodePolicy
  Worker_Node_Role = module.iam.Worker_Node_Role
}
