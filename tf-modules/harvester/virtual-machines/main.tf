resource "harvester_image" "image" {
  name      = var.os_image_name
  namespace = "harvester-public"

  display_name = var.os_image
  source_type  = "download"
  url          = var.os_image_url
}

resource "harvester_virtualmachine" "default" {
  count                = var.vm_count
  name                 = "${var.prefix}-vm-${count.index + 1}"
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
  hostname        = "${var.prefix}-vm-${count.index + 1}"
  reserved_memory = "256Mi"
  machine_type    = "q35"

  network_interface {
    name           = "nic-1"
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "${var.vm_disk_size}Gi"
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.image.id
    auto_delete = true
  }

  disk {
    name        = "emptydisk"
    type        = "disk"
    size        = "${var.vm_data_disk_size}Gi"
    bus         = "virtio"
    auto_delete = true
  }
}
