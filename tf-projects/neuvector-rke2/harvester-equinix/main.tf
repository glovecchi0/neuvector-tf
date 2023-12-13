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

data "local_file" "ssh-public-key" {
  depends_on = [module.harvester-equinix]
  filename   = local.public_ssh_key_path
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

# HARVESTER VIRTUAL MACHINES - RKE2 CLUSTER & NEUVECTOR

resource "random_password" "token" {
  length  = 40
  special = false
}

locals {
  create_os_image                          = var.create_os_image == null ? false : true
  rke2_config_template                     = "${path.cwd}/rke2-config-yaml.tpl"
  rke2_token                               = random_password.token.result
  rke2_first_server_config_yaml_file       = "${path.cwd}/rke2-first-server-config-yaml.sh"
  rke2_additional_servers_config_yaml_file = "${path.cwd}/rke2-additional-servers-config-yaml.sh"
}

resource "local_file" "rke2-first-server-config-yaml" {
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

data "local_file" "rke2-first-server-config-yaml-content" {
  depends_on = [local_file.rke2-first-server-config-yaml]
  filename   = local.rke2_first_server_config_yaml_file
}

module "harvester-first-virtual-machine" {
  source = "../../../tf-modules/harvester/virtual-machines"
  #  create_os_image   = local.create_os_image
  #  os_image_name     = var.os_image_name
  #  os_image          = var.os_image
  #  os_image_url      = var.os_image_url
  prefix       = var.prefix
  vm_count     = 1
  vm_namespace = kubernetes_namespace.harvester-vms-namespace.metadata[0].name
  #  description       = var.description
  ssh_username = var.ssh_username
  #  cpu               = var.cpu
  #  memory            = var.memory
  #  vm_disk_size      = var.vm_disk_size
  #  vm_data_disk_size = var.vm_data_disk_size
  startup_script = data.local_file.rke2-first-server-config-yaml-content.content_base64
}

resource "local_file" "rke2-additional-servers-config-yaml" {
  depends_on = [module.harvester-first-virtual-machine]
  content = templatefile("${local.rke2_config_template}", {
    ssh_username = var.ssh_username,
    ssh_password = var.ssh_password,
    rke2_config  = var.rke2_config == null ? "false" : var.rke2_config,
    rke2_token   = local.rke2_token,
    rke2_version = var.rke2_version == null ? "false" : var.rke2_version,
    server_ip    = module.harvester-first-virtual-machine.harvester_first_virtual_machine_ip
  })
  file_permission = "0644"
  filename        = local.rke2_additional_servers_config_yaml_file
}

data "local_file" "rke2-additional-servers-config-yaml-content" {
  depends_on = [local_file.rke2-additional-servers-config-yaml]
  filename   = local.rke2_additional_servers_config_yaml_file
}

module "harvester-additional-virtual-machines" {
  source          = "../../../tf-modules/harvester/virtual-machines"
  create_os_image = local.create_os_image
  #  os_image_name     = var.os_image_name
  #  os_image          = var.os_image
  #  os_image_url      = var.os_image_url
  prefix       = var.prefix
  vm_count     = var.vm_count - 1
  vm_namespace = kubernetes_namespace.harvester-vms-namespace.metadata[0].name
  #  description       = var.description
  ssh_username = var.ssh_username
  #  cpu               = var.cpu
  #  memory            = var.memory
  #  vm_disk_size      = var.vm_disk_size
  #  vm_data_disk_size = var.vm_data_disk_size
  startup_script = data.local_file.rke2-additional-servers-config-yaml-content.content_base64
}

# RKE2 CLUSTER & NEUVECTOR DONE
