locals {
  kc_path    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  certs_path = path.module
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
  kubernetes = {
    config_path = local_file.kube_config_yaml.filename
  }
}

resource "null_resource" "generate_certs" {
  depends_on = [local_file.kube_config_yaml]
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ${local.certs_path}
      openssl genrsa -out ${local.certs_path}/ca.key 2048
      openssl req -x509 -sha256 -new -nodes -key ${local.certs_path}/ca.key -days 3650 -out ${local.certs_path}/ca.crt -subj "/CN=neuvector-ca"
      openssl genrsa -out ${local.certs_path}/tls.key 2048
      openssl req -new -key ${local.certs_path}/tls.key -sha256 -out ${local.certs_path}/cert.csr -subj "/CN=neuvector"
      openssl x509 -req -sha256 -in ${local.certs_path}/cert.csr -CA ${local.certs_path}/ca.crt -CAkey ${local.certs_path}/ca.key -CAcreateserial -out ${local.certs_path}/tls.crt -days 3650
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}

data "local_file" "ca_crt" {
  depends_on = [null_resource.generate_certs]
  filename   = "${local.certs_path}/ca.crt"
}

data "local_file" "tls_crt" {
  depends_on = [null_resource.generate_certs]
  filename   = "${local.certs_path}/tls.crt"
}

data "local_file" "tls_key" {
  depends_on = [null_resource.generate_certs]
  filename   = "${local.certs_path}/tls.key"
}

resource "kubernetes_namespace" "neuvector" {
  depends_on = [null_resource.generate_certs]
  metadata {
    name = "cattle-neuvector-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].name
    ]
  }
}

resource "kubernetes_secret" "internal_cert" {
  depends_on = [null_resource.generate_certs, kubernetes_namespace.neuvector]

  metadata {
    name      = "neuvector-internal-certs"
    namespace = kubernetes_namespace.neuvector.metadata[0].name
  }

  data = {
    "ca.crt"  = data.local_file.ca_crt.content
    "tls.crt" = data.local_file.tls_crt.content
    "tls.key" = data.local_file.tls_key.content
  }

  type = "Opaque"
}

resource "helm_release" "neuvector_core" {
  depends_on = [kubernetes_secret.internal_cert]
  name       = "neuvector"
  repository = "https://neuvector.github.io/neuvector-helm/"
  chart      = "core"
  #create_namespace = true
  namespace = "cattle-neuvector-system"

  values = [
    "${file("${path.cwd}/custom_helm_values.yml")}"
  ]

  set = [
    {
      name  = "controller.secret.data.userinitcfg\\.yaml.users[0].Password"
      value = var.neuvector_password
    }
  ]
}

data "kubernetes_service" "neuvector_service_webui" {
  metadata {
    name      = "neuvector-service-webui"
    namespace = resource.helm_release.neuvector_core.namespace
  }
}
