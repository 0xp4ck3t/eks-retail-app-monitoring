resource "aws_eks_cluster" "k8_weather_app" {
  name     = "k8_weather_app"
  role_arn = var.eks_role
  version = var.k8_version
  vpc_config {
    subnet_ids = var.private_sn
  }
  depends_on = [
    var.AmazonEKSClusterPolicy, var.K8-AmazonEKSVPCResourceController
  ]
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
  upgrade_policy {
    support_type = "STANDARD"
  }
  bootstrap_self_managed_addons = false
}

resource "aws_eks_addon" "vpc-cni" {
  addon_name   = "vpc-cni"
  cluster_name = aws_eks_cluster.k8_weather_app.name
  addon_version            = "v1.19.0-eksbuild.1"
  pod_identity_association {
    role_arn        = var.AWS_EKS_VPC_CNI_Role
    service_account = "aws-node"
  }
  depends_on = [var.AWS_EKS_VPC_CNI_Role]


}

resource "aws_eks_addon" "kube-proxy" {
  addon_name   = "kube-proxy"
  cluster_name = aws_eks_cluster.k8_weather_app.name
  addon_version = "v1.31.2-eksbuild.3"
}


resource "aws_eks_addon" "EksPodIdentityAgent" {
  addon_name   = "eks-pod-identity-agent"
  cluster_name = aws_eks_cluster.k8_weather_app.name
}

resource "aws_eks_addon" "coredns" {
  addon_name   = "coredns"
  cluster_name = aws_eks_cluster.k8_weather_app.name
  addon_version = "v1.11.3-eksbuild.1"

  depends_on = [aws_eks_addon.kube-proxy, aws_eks_addon.EksPodIdentityAgent, aws_eks_addon.vpc-cni, aws_eks_node_group.worker_nodes]
}

resource "aws_eks_node_group" "worker_nodes" {
  cluster_name    = aws_eks_cluster.k8_weather_app.name
  node_group_name = "Worker_Nodes"
  node_role_arn   = var.Worker_Node_Role
  subnet_ids      = var.private_sn

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
    depends_on = [
    var.AmazonEKSWorkerNodePolicy,
    var.AmazonEKS_CNI_Policy,
    var.AmazonEC2ContainerRegistryReadOnly,
  ]
}