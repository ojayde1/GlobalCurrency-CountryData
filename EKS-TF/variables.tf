# --- Project-wide Variables ---

variable "project_name" {
  description = "A unique name for the project, used for naming resources."
  type        = string
  default     = "globalcurrency-countrydata" # Consistent with previous discussions
}

variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "eu-west-1" # You can change this to your preferred region (e.g., "us-east-2")
}

# --- EKS Cluster Variables ---

# variable "eks_cluster_version" {
#   description = "Kubernetes version for the EKS cluster."
#   type        = string
#   default     = "1.28" # Recommended to use a recent, stable EKS version
# }

# --- EKS Node Group Variables ---

variable "eks_node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes."
  type        = string
  default     = "t3.medium" # t2.medium is older, t3.medium is a good general-purpose choice
}

variable "eks_node_group_desired_size" {
  description = "Desired number of EC2 instances in the EKS node group."
  type        = number
  default     = 1 # Consistent with your deployment.yml replica count
}

variable "eks_node_group_max_size" {
  description = "Maximum number of EC2 instances in the EKS node group."
  type        = number
  default     = 2 # Allows for scaling up during updates or increased load
}

variable "eks_node_group_min_size" {
  description = "Minimum number of EC2 instances in the EKS node group."
  type        = number
  default     = 1 # Ensures at least one node is always running
}

# --- Application-specific Variables ---

variable "docker_hub_username" {
  description = "Your Docker Hub username for pulling the application image."
  type        = string
  # IMPORTANT: Provide your actual Docker Hub username here, or pass it via CLI/env var.
  default = "ojayde35"
}

variable "app_replica_count" {
  description = "Number of replicas for the application deployment in Kubernetes."
  type        = number
  default     = 2 # Matches your typical desired replica count
}
