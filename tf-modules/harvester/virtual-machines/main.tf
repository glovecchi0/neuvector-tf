resource "harvester_image" "image" {
  count     = var.create_os_image == true ? 1 : 0
  name      = var.os_image_name
  namespace = var.vm_namespace

  display_name = var.os_image
  source_type  = "download"
  url          = var.os_image_url
}

resource "random_string" "random" {
  length  = 4
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "harvester_virtualmachine" "default" {
  count                = var.vm_count
  name                 = "${var.prefix}-vm-${count.index + 1}-${random_string.random.result}"
  namespace            = var.vm_namespace
  restart_after_update = true

  description = var.description
  tags = {
    ssh-user = var.ssh_username
  }

  cpu    = var.cpu
  memory = "${var.memory}Gi"

  efi         = true
  secure_boot = true

  run_strategy    = "RerunOnFailure"
  hostname        = "${var.prefix}-vm-${count.index + 1}-${random_string.random.result}"
  reserved_memory = "256Mi"
  machine_type    = "q35"

  network_interface {
    name           = "nic-1"
    type           = "bridge" #https://groups.google.com/g/kubevirt-dev/c/HyMWzPQGBoM
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "${var.vm_disk_size}Gi"
    bus        = "virtio"
    boot_order = 1

    image       = "${var.vm_namespace}/${var.os_image_name}"
    auto_delete = true
  }

  disk {
    name        = "emptydisk"
    type        = "disk"
    size        = "${var.vm_data_disk_size}Gi"
    bus         = "virtio"
    auto_delete = true
  }

  cloudinit {
    user_data_base64 = var.startup_script
  }

  depends_on = [
    harvester_image.image
  ]
}
