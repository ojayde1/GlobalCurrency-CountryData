# --- IAM Roles for EKS Cluster ---

# Data source for the EKS Cluster's assume role policy
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project_name}-eks-cluster-role" # Using project_name variable
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Project = var.project_name
  }
}

# Attach AmazonEKSClusterPolicy to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# --- VPC and Subnet Data Sources (using default VPC) ---

# Get data for the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get data for public subnets within the default VPC
# EKS cluster endpoint typically needs to be in public subnets for external access
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  # Ensure you have at least two public subnets for EKS
  # If you don't have enough public subnets in your default VPC,
  # this data source might fail or EKS might not provision correctly.
}

# --- Security Group for EKS Cluster ---
# This security group is essential for EKS cluster control plane communication
# and for the Load Balancer to reach your application pods.
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "Security group for EKS cluster communication"
  vpc_id      = data.aws_vpc.default.id # Use the default VPC ID

  # Allow all outbound traffic (EKS needs to reach various AWS services)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all inbound traffic for simplicity in this project.
  # In production, this should be highly restricted (e.g., specific ports/IPs).
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project_name
  }
}


# --- EKS Cluster Provisioning ---
resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-cluster" # Using project_name variable
  role_arn = aws_iam_role.eks_cluster_role.arn
#   version  = var.eks_cluster_version # Using variable for EKS version

  vpc_config {
    subnet_ids         = data.aws_subnets.public.ids # Using public subnets from default VPC
    security_group_ids = [aws_security_group.eks_cluster_sg.id] # Attach the cluster SG
  }

  tags = {
    Project = var.project_name
  }

  # Ensure that IAM Role permissions are created before EKS Cluster handling.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

# --- IAM Roles for EKS Node Group ---

# EKS Node Group IAM Role
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-group-role" # Using project_name variable

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Project = var.project_name
  }
}

# Attach necessary policies to the EKS Node Group Role
resource "aws_iam_role_policy_attachment" "eks_node_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# --- EKS Node Group Creation ---
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_name}-node-group" # Using project_name variable
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.public.ids # Using public subnets from default VPC
  instance_types  = [var.eks_node_instance_type] # Using variable for instance type

  scaling_config {
    desired_size = var.eks_node_group_desired_size
    max_size     = var.eks_node_group_max_size
    min_size     = var.eks_node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_node_worker_policy,
    aws_iam_role_policy_attachment.eks_node_cni_policy,
    aws_iam_role_policy_attachment.eks_node_ecr_policy,
    aws_eks_cluster.this, # Depend on the cluster being ready
  ]

  tags = {
    Project = var.project_name
  }
}

