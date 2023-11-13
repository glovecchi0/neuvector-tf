variable "prefix" {
  description = "The prefix used in front of all AWS resources"
}

variable "vpc_ip_cidr_range" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Range of private IPs available for the AWS VPC"
}

variable "subnet_ip_cidr_range" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Range of private IPs available for the AWS Subnet"
}

variable "vpc" {
  description = "AWS VPC ID used for all resources"
  default     = null
}

variable "subnet" {
  description = "AWS Subnet ID used for all resources"
  default     = null
}

variable "instance_count" {
  default     = 1
  description = "The number of instances per Node Group"
}

## Option 1 - AWS CLI
# variable "aws_access_key" {}
# variable "aws_secret_key" {}
# variable "aws_session_token" {}

## Option 3 - IAM Identity Center credentials
# variable "aws_profile" {}

variable "aws_region" {
  description = "AWS Region to create the resources"
}
