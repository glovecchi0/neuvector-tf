locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

module "google_kubernetes_engine" {
  source                 = "../../tf-modules/google-cloud/gke"
  prefix                 = var.prefix
  project_id             = var.project_id
  region                 = var.region
  vpc                    = var.vpc
  subnet                 = var.subnet
  cluster_version_prefix = var.cluster_version_prefix
  instance_count         = var.instance_count
  instance_disk_size     = var.instance_disk_size
  disk_type              = var.disk_type
  image_type             = var.image_type
  instance_type          = var.instance_type
}

resource "null_resource" "first_setup" {
  depends_on = [module.google_kubernetes_engine.kubernetes_cluster_node_pool]
  provisioner "local-exec" {
    command = "sh ./first_setup.sh"
  }
}

resource "local_file" "kube_config_yaml" {
  depends_on = [null_resource.first_setup]

  content = templatefile("../../tf-modules/google-cloud/gke/kubeconfig.yml.tmpl", {
    cluster_name    = module.google_kubernetes_engine.cluster_name,
    endpoint        = module.google_kubernetes_engine.cluster_endpoint,
    cluster_ca      = module.google_kubernetes_engine.cluster_ca_certificate,
    client_cert     = module.google_kubernetes_engine.client_certificate,
    client_cert_key = module.google_kubernetes_engine.client_key
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
