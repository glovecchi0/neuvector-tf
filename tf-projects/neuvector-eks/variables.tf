variable "aws_region" {
  description = "AWS Region to create the resources"
  type        = string
  default     = "eu-west-1"
}

variable "prefix" {
  description = "The prefix used in front of all AWS resources"
  type        = string
}

variable "vpc_ip_cidr_range" {
  description = "Range of private IPs available for the AWS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_ip_cidr_range" {
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane"
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc" {
  description = "AWS VPC ID used for all resources"
  type        = string
  default     = null
}

variable "subnet" {
  description = "AWS Subnet IDs used for all resources. Must be in at least two different availability zones"
  type        = string
  default     = null
}

variable "allowed_ip_cidr_range" {
  description = "Range of IPs that can reach the cluster API Server"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_count" {
  description = "The number of instances per Node Group"
  type        = number
  default     = 3
}

variable "instance_disk_size" {
  description = "Size of the disk attached to each node, specified in GB"
  type        = number
  default     = "50"
}

variable "instance_type" {
  description = "The name of a AWS EC2 machine type"
  type        = list(any)
  default     = ["t2.xlarge"]
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the GKE cluster"
  type        = string
  default     = null
}

variable "kube_config_filename" {
  description = "Filename to write the kubeconfig"
  type        = string
  default     = null
}

variable "neuvector_password" {
  description = "Password for the NeuVector admin account"
}
