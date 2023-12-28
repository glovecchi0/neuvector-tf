data "equinix_metal_project" "project" {
  name = var.project_name
}

data "equinix_metal_ip_block_ranges" "address_block" {
  project_id = data.equinix_metal_project.project.project_id
  metro      = var.metro
}

data "equinix_metal_spot_market_request" "seed_req" {
  count      = var.spot_instance ? 1 : 0
  request_id = equinix_metal_spot_market_request.seed_spot_request.0.id
}

data "equinix_metal_spot_market_request" "join_req" {
  count      = var.spot_instance ? var.instance_count - 1 : 0
  request_id = equinix_metal_spot_market_request.join_spot_request[count.index].id
}

data "equinix_metal_device" "seed_device" {
  device_id = var.spot_instance ? data.equinix_metal_spot_market_request.seed_req.0.device_ids[0] : equinix_metal_device.seed.0.id
}

data "equinix_metal_device" "join_devices" {
  count     = var.instance_count - 1
  device_id = var.spot_instance ? data.equinix_metal_spot_market_request.join_req[count.index].device_ids[0] : equinix_metal_device.join[count.index].id
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "random_password" "token" {
  length  = 16
  special = false
}

locals {
  new_key_pair_path = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
}

resource "tls_private_key" "ssh_private_key" {
  count     = var.create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.new_key_pair_path
  content         = tls_private_key.ssh_private_key[0].private_key_openssh
  file_permission = "0600"
}

resource "local_file" "public_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = "${path.cwd}/${var.prefix}-ssh_public_key.pem"
  content         = tls_private_key.ssh_private_key[0].public_key_openssh
  file_permission = "0600"
}

resource "equinix_metal_reserved_ip_block" "harvester_vip" {
  project_id = data.equinix_metal_project.project.project_id
  metro      = var.metro
  type       = "public_ipv4"
  quantity   = 1
}

resource "equinix_metal_device" "seed" {
  count            = var.instance_count >= 1 && !var.spot_instance ? 1 : 0
  hostname         = "${var.prefix}-1"
  plan             = var.plan
  metro            = var.metro
  operating_system = "custom_ipxe"
  billing_cycle    = var.billing_cycle
  project_id       = data.equinix_metal_project.project.project_id
  ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
  always_pxe       = "false"
  user_data = templatefile("${path.module}/create.tpl", {
    version                  = var.harvester_version,
    password                 = random_password.password.result,
    token                    = random_password.token.result,
    vip                      = equinix_metal_reserved_ip_block.harvester_vip.network,
    hostname_prefix          = var.prefix,
    ssh_key                  = var.ssh_public_key_path == null ? "${file("${path.cwd}/${var.prefix}-ssh_public_key.pem")}" : "${file("${var.ssh_public_key_path}")}",
    count                    = "1",
    cluster_registration_url = var.rancher_api_url != "" ? rancher2_cluster.rancher_cluster[0].cluster_registration_token[0].manifest_url : ""
  })
}

resource "equinix_metal_spot_market_request" "seed_spot_request" {
  count            = var.instance_count >= 1 && var.spot_instance ? 1 : 0
  project_id       = data.equinix_metal_project.project.project_id
  max_bid_price    = var.max_bid_price
  metro            = var.metro
  devices_min      = 1
  devices_max      = 1
  wait_for_devices = true

  instance_parameters {
    hostname         = "${var.prefix}-1"
    billing_cycle    = "hourly"
    operating_system = "custom_ipxe"
    ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
    plan             = var.plan
    userdata = templatefile("${path.module}/create.tpl", {
      version                  = var.harvester_version,
      password                 = random_password.password.result,
      token                    = random_password.token.result,
      vip                      = equinix_metal_reserved_ip_block.harvester_vip.network,
      hostname_prefix          = var.prefix,
      ssh_key                  = var.ssh_public_key_path == null ? "${file("${path.cwd}/${var.prefix}-ssh_public_key.pem")}" : "${file("${var.ssh_public_key_path}")}",
      count                    = "1",
      cluster_registration_url = var.rancher_api_url != "" ? rancher2_cluster.rancher_cluster[0].cluster_registration_token[0].manifest_url : ""
    })
  }
}

resource "equinix_metal_ip_attachment" "first_address_assignment" {
  device_id     = var.spot_instance ? data.equinix_metal_spot_market_request.seed_req.0.device_ids[0] : equinix_metal_device.seed.0.id
  cidr_notation = join("/", [cidrhost(equinix_metal_reserved_ip_block.harvester_vip.cidr_notation, 0), "32"])
}

resource "equinix_metal_device" "join" {
  count            = var.spot_instance ? 0 : var.instance_count - 1
  hostname         = "${var.prefix}-${count.index + 2}"
  plan             = var.plan
  metro            = var.metro
  operating_system = "custom_ipxe"
  billing_cycle    = var.billing_cycle
  project_id       = data.equinix_metal_project.project.project_id
  ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
  always_pxe       = "false"
  user_data = templatefile("${path.module}/join.tpl", {
    version         = var.harvester_version,
    password        = random_password.password.result,
    token           = random_password.token.result,
    seed            = equinix_metal_reserved_ip_block.harvester_vip.network,
    hostname_prefix = var.prefix,
    ssh_key         = var.ssh_public_key_path == null ? "${file("${path.cwd}/${var.prefix}-ssh_public_key.pem")}" : "${file("${var.ssh_public_key_path}")}",
    count           = "${count.index + 2}"
  })
}

resource "equinix_metal_spot_market_request" "join_spot_request" {
  count            = var.spot_instance ? var.instance_count - 1 : 0
  project_id       = data.equinix_metal_project.project.project_id
  max_bid_price    = var.max_bid_price
  metro            = var.metro
  devices_min      = 1
  devices_max      = 1
  wait_for_devices = true

  instance_parameters {
    hostname         = "${var.prefix}-${count.index + 2}"
    billing_cycle    = "hourly"
    operating_system = "custom_ipxe"
    ipxe_script_url  = "${var.ipxe_script}${element(split("v", var.harvester_version), 1)}"
    plan             = var.plan
    userdata = templatefile("${path.module}/join.tpl", {
      version         = var.harvester_version,
      password        = random_password.password.result,
      token           = random_password.token.result,
      seed            = equinix_metal_reserved_ip_block.harvester_vip.network,
      hostname_prefix = var.prefix,
      ssh_key         = var.ssh_public_key_path == null ? "${file("${path.cwd}/${var.prefix}-ssh_public_key.pem")}" : "${file("${var.ssh_public_key_path}")}",
      count           = "${count.index + 2}"
    })
  }
}

resource "equinix_metal_vlan" "vlans" {
  count      = var.vlan_count
  project_id = data.equinix_metal_project.project.project_id
  metro      = var.metro
}

resource "equinix_metal_device_network_type" "seed_network_type" {
  device_id = data.equinix_metal_device.seed_device.id
  type      = "hybrid"
}

resource "equinix_metal_device_network_type" "join_network_type" {
  count     = var.vlan_count * (var.instance_count - 1)
  device_id = data.equinix_metal_device.join_devices[count.index % (var.instance_count - 1)].id
  type      = "hybrid"
}

resource "equinix_metal_port_vlan_attachment" "vlan_attach_seed" {
  count     = var.vlan_count
  device_id = data.equinix_metal_device.seed_device.id
  vlan_vnid = equinix_metal_vlan.vlans[count.index].vxlan
  port_name = "bond0"
}

resource "equinix_metal_port_vlan_attachment" "vlan_attach_join" {
  count     = var.vlan_count * (var.instance_count - 1)
  device_id = data.equinix_metal_device.join_devices[count.index % (var.instance_count - 1)].id
  vlan_vnid = equinix_metal_vlan.vlans[floor(count.index / (var.instance_count - 1))].vxlan
  port_name = "bond0"
}

resource "rancher2_cluster" "rancher_cluster" {
  count       = var.rancher_api_url != "" ? 1 : 0
  name        = var.prefix
  description = "${var.prefix} created by Terraform"
}
