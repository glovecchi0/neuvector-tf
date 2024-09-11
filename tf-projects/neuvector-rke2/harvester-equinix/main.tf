# INFRASTRUCTURE - Harvester hypervisor on Equinix infrastructure

locals {
  private_ssh_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  public_ssh_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
}

module "harvester_equinix" {
  source               = "../../../tf-modules/harvester/infrastructure/equinix"
  prefix               = var.prefix
  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = local.private_ssh_key_path
  ssh_public_key_path  = local.public_ssh_key_path
  harvester_version    = var.harvester_version
  instance_count       = var.instance_count
  metal_create_project = var.metal_create_project
  project_name         = var.project_name
  organization_id      = var.organization_id
  project_id           = var.project_id
  plan                 = var.plan
  billing_cycle        = var.billing_cycle
  metro                = var.metro
  ipxe_script          = var.ipxe_script
  spot_instance        = var.spot_instance
  max_bid_price        = var.max_bid_price
  use_cheapest_metro   = var.use_cheapest_metro
  ssh_key              = var.ssh_key
  vlan_count           = var.vlan_count
  rancher_api_url      = var.rancher_api_url
  rancher_access_key   = var.rancher_access_key
  rancher_secret_key   = var.rancher_secret_key
  rancher_insecure     = var.rancher_insecure
}

resource "null_resource" "wait_harvester_services_startup" {
  depends_on = [module.harvester_equinix]
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
      HARVESTER_URL = module.harvester_equinix.harvester_url
    }
  }
}

locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

data "local_file" "ssh_private_key" {
  depends_on = [null_resource.wait_harvester_services_startup]
  filename   = local.private_ssh_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [data.local_file.ssh_private_key]
  host       = module.harvester_equinix.seed_ip
  commands = [
    "sudo sed 's/127.0.0.1/${module.harvester_equinix.seed_ip}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = "rancher"
  private_key = data.local_file.ssh_private_key.content
}

resource "local_file" "kube_config_yaml" {
  depends_on      = [ssh_resource.retrieve_kubeconfig]
  filename        = local.kc_file
  file_permission = "0600"
  content         = ssh_resource.retrieve_kubeconfig.result
}

provider "harvester" {
  kubeconfig = local_file.kube_config_yaml.filename
}

provider "kubernetes" {
  config_path = local_file.kube_config_yaml.filename
}

resource "kubernetes_namespace" "harvester_vms_namespace" {
  depends_on = [local_file.kube_config_yaml]
  metadata {
    name = var.vm_namespace
  }
}

# INFRASTRUCTURE DONE

# HARVESTER VIRTUAL MACHINES - RKE2 CLUSTER & NEUVECTOR

resource "random_password" "token" {
  length  = 40
  special = false
}

locals {
  rke2_config_template                     = "${path.cwd}/rke2-config-yaml.tpl"
  rke2_token                               = random_password.token.result
  rke2_first_server_config_yaml_file       = "${path.cwd}/rke2_first_server_config_yaml.sh"
  rke2_additional_servers_config_yaml_file = "${path.cwd}/rke2_additional_servers_config_yaml.sh"
}

resource "local_file" "rke2_first_server_config_yaml" {
  depends_on = [kubernetes_namespace.harvester_vms_namespace]
  content = templatefile("${local.rke2_config_template}", {
    ssh_username = var.ssh_username,
    ssh_password = var.ssh_password,
    rke2_config  = var.rke2_config == null ? "false" : var.rke2_config,
    rke2_token   = local.rke2_token,
    rke2_version = var.rke2_version == null ? "false" : var.rke2_version,
    server_ip    = "false"
  })
  file_permission = "0644"
  filename        = local.rke2_first_server_config_yaml_file
}

data "local_file" "rke2_first_server_config_yaml-content" {
  depends_on = [local_file.rke2_first_server_config_yaml]
  filename   = local.rke2_first_server_config_yaml_file
}

module "harvester_first_virtual_machine" {
  source            = "../../../tf-modules/harvester/virtual-machines"
  create_os_image   = var.create_os_image
  os_image_name     = var.os_image_name
  os_image          = var.os_image
  os_image_url      = var.os_image_url
  prefix            = var.prefix
  vm_count          = 1
  vm_namespace      = kubernetes_namespace.harvester_vms_namespace.metadata[0].name
  description       = var.description
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  cpu               = var.cpu
  memory            = var.memory
  vm_disk_size      = var.vm_disk_size
  vm_data_disk_size = var.vm_data_disk_size
  startup_script    = data.local_file.rke2_first_server_config_yaml-content.content_base64
}

resource "local_file" "rke2_additional_servers_config_yaml" {
  depends_on = [module.harvester_first_virtual_machine]
  content = templatefile("${local.rke2_config_template}", {
    ssh_username = var.ssh_username,
    ssh_password = var.ssh_password,
    rke2_config  = var.rke2_config == null ? "false" : var.rke2_config,
    rke2_token   = local.rke2_token,
    rke2_version = var.rke2_version == null ? "false" : var.rke2_version,
    server_ip    = module.harvester_first_virtual_machine.harvester_first_virtual_machine_ip
  })
  file_permission = "0644"
  filename        = local.rke2_additional_servers_config_yaml_file
}

data "local_file" "rke2_additional_servers_config_yaml-content" {
  depends_on = [local_file.rke2_additional_servers_config_yaml]
  filename   = local.rke2_additional_servers_config_yaml_file
}

module "harvester_additional_virtual_machines" {
  source            = "../../../tf-modules/harvester/virtual-machines"
  create_os_image   = false
  os_image_name     = var.os_image_name
  os_image          = var.os_image
  os_image_url      = var.os_image_url
  prefix            = var.prefix
  vm_count          = var.vm_count - 1
  vm_namespace      = kubernetes_namespace.harvester_vms_namespace.metadata[0].name
  description       = var.description
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  cpu               = var.cpu
  memory            = var.memory
  vm_disk_size      = var.vm_disk_size
  vm_data_disk_size = var.vm_data_disk_size
  startup_script    = data.local_file.rke2_additional_servers_config_yaml-content.content_base64
}

# RKE2 CLUSTER & NEUVECTOR DONE
