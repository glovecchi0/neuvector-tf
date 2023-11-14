variable "prefix" {
  description = "The prefix used in front of all AWS resources"
}

variable "vpc_ip_cidr_range" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Range of private IPs available for the AWS VPC"
}

variable "subnet_ip_cidr_range" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "vpc" {
  description = "AWS VPC ID used for all resources"
  default     = null
}

variable "subnet" {
  description = "AWS Subnet IDs used for all resources. Must be in at least two different availability zones."
  default     = null
}

variable "instance_count" {
  default     = 1
  description = "The number of instances per Node Group"
}

# variable "aws_access_key" {}

# variable "aws_secret_key" {}

# variable "aws_session_token" {}

variable "aws_region" {
  description = "AWS Region to create the resources"
}
