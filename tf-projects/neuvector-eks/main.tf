locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

module "aws_elastic_kubernetes_service" {
  source                = "../../tf-modules/aws/eks"
  prefix                = var.prefix
  aws_region            = var.aws_region
  vpc_ip_cidr_range     = var.vpc_ip_cidr_range
  subnet_ip_cidr_range  = var.subnet_ip_cidr_range
  vpc                   = var.vpc
  subnet                = var.subnet
  allowed_ip_cidr_range = var.allowed_ip_cidr_range
  instance_count        = var.instance_count
  instance_disk_size    = var.instance_disk_size
  instance_type         = var.instance_type
}

resource "local_file" "kube_config_yaml" {
  depends_on = [module.aws_elastic_kubernetes_service]

  content = templatefile("../../tf-modules/aws/eks/kubeconfig.yml.tmpl", {
    cluster_name = module.aws_elastic_kubernetes_service.cluster_name,
    region       = var.aws_region,
    endpoint     = module.aws_elastic_kubernetes_service.cluster_endpoint,
    cluster_ca   = module.aws_elastic_kubernetes_service.cluster_ca_certificate
  })
  file_permission = "0600"
  filename        = local.kc_file
}

provider "kubernetes" {
  config_path = local_file.kube_config_yaml.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_yaml.filename

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["--region", "${var.aws_region}", "eks", "get-token", "--cluster-name", "${var.prefix}-cluster", "--output", "json"]
      command     = "aws"
    }
  }
}

resource "helm_release" "neuvector_core" {
  depends_on       = [local_file.kube_config_yaml]
  name             = "neuvector"
  repository       = "https://neuvector.github.io/neuvector-helm/"
  chart            = "core"
  create_namespace = true
  namespace        = "cattle-neuvector-system"

  values = [
    "${file("${path.cwd}/custom_helm_values.yml")}"
  ]

  set {
    name  = "controller.secret.data.userinitcfg\\.yaml.users[0].Password"
    value = var.neuvector_password
  }
}

data "kubernetes_service" "neuvector_service_webui" {
  metadata {
    name      = "neuvector-service-webui"
    namespace = resource.helm_release.neuvector_core.namespace
  }
}
