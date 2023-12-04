terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "1.20.0"
    }

    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.2.0"
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

  required_version = ">= 0.14"
}

provider "equinix" {}

provider "rancher2" {
  api_url    = var.rancher_api_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure   = var.rancher_insecure
}

provider "kubernetes" {
  config_path = "${path.cwd}/${var.prefix}_kube_config.yml"
}

provider "helm" {
  kubernetes {
    config_path = "${path.cwd}/${var.prefix}_kube_config.yml"
  }
}