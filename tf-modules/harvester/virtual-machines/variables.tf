variable "create_os_image" {
  description = "Harvester's VMs Image"
  type        = bool
  default     = true
}

variable "os_image_name" {
  description = "Harvester's VMs OS Image name"
  type        = string
  default     = "ubuntu22"
}

variable "os_image" {
  description = "Harvester's VMs OS Image display name"
  type        = string
  default     = "ubuntu-22.04-server-cloudimg-amd64"
}

variable "os_image_url" {
  description = "Harvester's VMs OS Image URL"
  type        = string
  default     = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "prefix" {
  description = "The prefix used in front of all Equinix resources"
  type        = string
  default     = "equinix-vm-tf"
}

variable "vm_count" {
  description = "The number of instances"
  type        = number
  default     = 3
}

variable "vm_namespace" {
  description = "VMs namespace"
  type        = string
  default     = "default"
}

variable "description" {
  description = "VMs description"
  type        = string
  default     = "Created using Terraform"
}

variable "ssh_username" {
  description = "Username used for SSH login"
  default     = "ubuntu"
}

variable "ssh_password" {
  description = "Password used for SSH login"
  type        = string
  default     = null
}

variable "cpu" {
  description = "VMs CPU"
  type        = number
  default     = 8
}

variable "memory" {
  description = "VMs Memory, specified in GB"
  type        = number
  default     = 16
}

variable "vm_disk_size" {
  description = "Size of the root disk attached to each VMs, specified in GB"
  type        = number
  default     = 50
}

variable "vm_data_disk_size" {
  description = "Size of the data disk attached to each VMs, specified in GB"
  type        = number
  default     = 10
}

variable "startup_script" {
  description = "Custom startup script"
  type        = string
  default     = null
}
