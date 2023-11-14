data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  count      = var.vpc == null ? 1 : 0
  cidr_block = var.vpc_ip_cidr_range
}

resource "aws_subnet" "subnet" {
  count             = var.subnet == null ? 2 : 0
  vpc_id            = var.vpc == null ? aws_vpc.vpc[0].id : var.vpc
  cidr_block        = var.subnet_ip_cidr_range[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

# EKS Cluster Resources
resource "aws_iam_role" "cluster-iam-role" {
  name = "${var.prefix}-cluster-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-iam-role.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster-iam-role.name
}

resource "aws_eks_cluster" "primary" {
  name     = "${var.prefix}-cluster"
  role_arn = aws_iam_role.cluster-iam-role.arn

  vpc_config {
    subnet_ids = var.subnet == null ? [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id] : [var.subnet]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]
}

resource "local_file" "kube-config-export" {
  content = templatefile("${path.module}/template-kube_config.yml", {
    cluster_name = aws_eks_cluster.primary.name,
    endpoint     = aws_eks_cluster.primary.endpoint,
    cluster_ca   = aws_eks_cluster.primary.certificate_authority.0.data
  })
  file_permission = "0600"
  filename        = "${path.cwd}/${var.prefix}_kube_config.yml"
}

# EKS Worker Nodes Resources
resource "aws_iam_role" "node-iam-role" {
  name = "${var.prefix}-node-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-iam-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-iam-role.name
}

resource "aws_iam_role_policy_attachment" "node-iam-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-iam-role.name
}

resource "aws_iam_role_policy_attachment" "node-iam-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-iam-role.name
}

resource "aws_eks_node_group" "primary-nodes" {
  cluster_name    = aws_eks_cluster.primary.name
  node_group_name = "primary-node-pool"
  node_role_arn   = aws_iam_role.node-iam-role.arn
  subnet_ids      = var.subnet == null ? [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id] : [var.subnet]

  scaling_config {
    desired_size = var.instance_count
    max_size     = var.instance_count
    min_size     = var.instance_count
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-iam-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-iam-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-iam-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
