module "harvester-equinix" {
  source       = "../../../tf-modules/harvester/infrastructure/equinix"
  prefix       = var.prefix
  project_name = var.project_name
  metro        = var.metro
  #  create_ssh_key_pair  = var.create_ssh_key_pair
  #  ssh_private_key_path = var.ssh_private_key_path
  #  ssh_public_key_path  = var.ssh_public_key_path
  #  ipxe_script          = var.ipxe_script
  #  vlan_count           = var.vlan_count
  #  instance_count       = var.instance_count
  #  plan                 = var.plan
  #  billing_cycle        = var.billing_cycle
  #  spot_instance        = var.spot_instance
  #  max_bid_price        = var.max_bid_price
  #  harvester_version    = var.harvester_version
  #  rancher_api_url      = var.rancher_api_url
  #  rancher_access_key   = var.rancher_access_key
  #  rancher_secret_key   = var.rancher_secret_key
  #  rancher_insecure     = var.rancher_insecure
}

#resource "null_resource" "first-setup" {
#  depends_on = [module.google-kubernetes-engine.kubernetes_cluster_node_pool]
#  provisioner "local-exec" {
#    command = "sh ./first-setup.sh"
#  }
#}

#resource "helm_release" "neuvector-core" {
#  depends_on       = [resource.null_resource.first-setup]
#  name             = "neuvector"
#  repository       = "https://neuvector.github.io/neuvector-helm/"
#  chart            = "core"
#  create_namespace = true
#  namespace        = "cattle-neuvector-system"
#
#  values = [
#    "${file("${path.cwd}/custom-helm-values.yaml")}"
#  ]
#
#  set {
#    name  = "controller.secret.data.userinitcfg\\.yaml.users[0].Password"
#    value = var.neuvector_password
#  }
#}

#data "kubernetes_service" "neuvector-service-webui" {
#  metadata {
#    name      = "neuvector-service-webui"
#    namespace = resource.helm_release.neuvector-core.namespace
#  }
#}
