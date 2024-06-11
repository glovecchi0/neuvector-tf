terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
  ## Option 1 - AWS CLI
  #  access_key = var.aws_access_key
  #  secret_key = var.aws_secret_key
  #  token      = var.aws_session_token
  ## Option 2 - Manually creating credential files
  #  shared_config_files      = ["~/.aws/config"]
  #  shared_credentials_files = ["~/.aws/credentials"]
  region = var.aws_region
}

provider "kubernetes" {
  config_path = "${path.cwd}/${var.prefix}_kube_config.yml"
}

provider "helm" {
  kubernetes {
    config_path = "${path.cwd}/${var.prefix}_kube_config.yml"
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["--region", "${var.aws_region}", "eks", "get-token", "--cluster-name", "${var.prefix}-cluster", "--output", "json"]
      command     = "aws"
    }
  }
}
