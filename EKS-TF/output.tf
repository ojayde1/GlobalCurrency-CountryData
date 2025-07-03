# Output the EKS cluster name
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

# Output the Kubernetes LoadBalancer endpoint
output "app_url" {
  description = "URL of the deployed Node.js application"
  value       = kubernetes_service.app_service.status.0.load_balancer.0.ingress.0.hostname
}
