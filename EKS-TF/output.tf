# Output the EKS cluster name
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

