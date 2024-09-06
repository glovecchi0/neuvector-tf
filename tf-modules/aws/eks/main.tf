data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  count      = var.vpc == null ? 1 : 0
  cidr_block = var.vpc_ip_cidr_range

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  count             = var.subnet == null ? 2 : 0
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = var.subnet_ip_cidr_range[count.index]
  # cidr_block        = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = var.vpc == null ? aws_vpc.vpc[0].id : var.vpc

  tags = {
    Name = "${var.prefix}-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  count  = var.vpc == null ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = "${var.prefix}-ig"
  }
}

resource "aws_route_table" "route-table" {
  count  = var.vpc == null ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway[0].id
  }
}

resource "aws_route_table_association" "rt-association" {
  count          = var.subnet == null ? 2 : 0
  subnet_id      = var.subnet == null ? "${aws_subnet.subnet.*.id[count.index]}" : var.subnet
  route_table_id = aws_route_table.route-table[0].id
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

resource "aws_security_group" "security-group" {
  count       = var.vpc == null ? 1 : 0
  name        = "${var.prefix}-sg"
  description = "Cluster communication with worker nodes."
  vpc_id      = aws_vpc.vpc[0].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-sg"
  }
}

resource "aws_security_group_rule" "ingress-workstation-https" {
  count             = var.vpc == null ? 1 : 0
  cidr_blocks       = [var.allowed_ip_cidr_range]
  description       = "Allow workstation (or a range of IPs) to communicate with the cluster API Server."
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.security-group[0].id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "primary" {
  name     = "${var.prefix}-cluster"
  role_arn = aws_iam_role.cluster-iam-role.arn

  vpc_config {
    security_group_ids = ["${aws_security_group.security-group[0].id}"]
    subnet_ids         = var.subnet == null ? [aws_subnet.subnet[0].id, aws_subnet.subnet[1].id] : [var.subnet]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSVPCResourceController,
  ]
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

  disk_size      = var.instance_disk_size
  instance_types = var.instance_type

  depends_on = [
    aws_iam_role_policy_attachment.node-iam-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-iam-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-iam-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
