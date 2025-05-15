terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.7"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
  }
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
