# INFRASTRUCTURE - Harvester hypervisor on Equinix infrastructure

locals {
  private_ssh_key_path = fileexists("${path.cwd}/${var.prefix}-ssh_private_key.pem") ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  public_ssh_key_path  = fileexists("${path.cwd}/${var.prefix}-ssh_public_key.pem") ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
}

module "harvester-equinix" {
  source       = "../../../tf-modules/harvester/infrastructure/equinix"
  prefix       = var.prefix
  project_name = var.project_name
  metro        = var.metro
  #  create_ssh_key_pair  = var.create_ssh_key_pair
  #  ssh_private_key_path = local.private_ssh_key_path
  #  ssh_public_key_path  = local.public_ssh_key_path
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

resource "null_resource" "wait-harvester-services-startup" {
  depends_on = [module.harvester-equinix]
  provisioner "local-exec" {
    command     = <<-EOF
      count=0
      while [ "$${count}" -lt 15 ]; do
        resp=$(curl -k -s -o /dev/null -w "%%{http_code}" $${HARVESTER_URL}ping)
        echo "Waiting for $${HARVESTER_URL}ping - response: $${resp}"
        if [ "$${resp}" = "200" ]; then
          ((count++))
        fi
        sleep 2
      done
      EOF
    interpreter = ["/bin/bash", "-c"]
    environment = {
      HARVESTER_URL = module.harvester-equinix.harvester_url
    }
  }
}

data "local_file" "ssh-private-key" {
  depends_on = [module.harvester-equinix]
  filename   = local.private_ssh_key_path
}

locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

resource "ssh_resource" "retrieve-kubeconfig" {
  depends_on = [data.local_file.ssh-private-key]
  host       = module.harvester-equinix.seed_ip
  commands = [
    "sudo sed 's/127.0.0.1/${module.harvester-equinix.seed_ip}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = "rancher"
  private_key = data.local_file.ssh-private-key.content
}

resource "local_file" "kubeconfig-yaml" {
  depends_on      = [ssh_resource.retrieve-kubeconfig]
  filename        = local.kc_file
  file_permission = "0600"
  content         = ssh_resource.retrieve-kubeconfig.result
}

resource "kubernetes_namespace" "harvester-vms-namespace" {
  depends_on = [local_file.kubeconfig-yaml]
  metadata {
    name = var.vm_namespace
  }
}

# INFRASTRUCTURE DONE

# HARVESTER VIRTUAL MACHINES - RKE2 CLUSTER

module "harvester-virtual-machines" {
  source = "../../../tf-modules/harvester/virtual-machines"
  #  os_image_name     = var.os_image_name
  #  os_image          = var.os_image
  #  os_image_url      = var.os_image_url
  prefix       = var.prefix
  vm_count     = var.vm_count
  vm_namespace = kubernetes_namespace.harvester-vms-namespace.metadata[0].name
  #  description       = var.description
  #  ssh_username      = var.ssh_username
  #  cpu               = var.cpu
  #  memory            = var.memory
  #  vm_disk_size      = var.vm_disk_size
  #  vm_data_disk_size = var.vm_data_disk_size
}

# RKE2 CLUSTER DONE

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
