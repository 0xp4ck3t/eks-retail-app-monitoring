# --- iam/main.tf ---

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "AWS_EKS_Role" {
  name               = "AWS_EKS_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.AWS_EKS_Role.name
}

resource "aws_iam_role_policy_attachment" "K8-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.AWS_EKS_Role.name
}


## CNI Role
data "aws_iam_policy_document" "assume_role_vpc_cni" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole","sts:TagSession"]
  }
}

resource "aws_iam_role" "AWS_EKS_VPC_CNI_Role" {
  name               = "AWS_EKS_VPC_CNI_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_vpc_cni.json
}

resource "aws_iam_role_policy_attachment" "AWS_EKS_VPC_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.AWS_EKS_VPC_CNI_Role.name
}



## WorkerNode Role
data "aws_iam_policy_document" "assume_worker_node" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "AWS_EKS_Worker_Node_Role" {
  name               = "Worker_Node_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_worker_node.json
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.AWS_EKS_Worker_Node_Role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.AWS_EKS_Worker_Node_Role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.AWS_EKS_Worker_Node_Role.name
}