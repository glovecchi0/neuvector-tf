variable "prefix" {}

variable "project_name" {}

variable "metro" {}

# variable "create_ssh_key_pair" {
#   description = "Specify if a new SSH key pair needs to be created for the instances"
#   default     = true
# }

variable "ssh_private_key_path" {
  type        = string
  description = "The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform)"
  default     = null
}

variable "ssh_public_key_path" {
  description = "The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform)"
  default     = null
}

# variable "ipxe_script" {}

# variable "vlan_count" {}

# variable "instance_count" {}

# variable "plan" {}

# variable "billing_cycle" {}

# variable "spot_instance" {}

# variable "max_bid_price" {}

# variable "harvester_version" {}

variable "rancher_api_url" {
  description = "Rancher API endpoint to manager your Harvester cluster"
  default     = ""
}

variable "rancher_access_key" {
  description = "Rancher Access Key"
  default     = ""
}

variable "rancher_secret_key" {
  description = "Rancher Secret Key"
  default     = ""
}

variable "rancher_insecure" {
  description = "Allow or not insecure connections to the Rancher API"
  default     = false
}

variable "kube_config_path" {
  type        = string
  description = "Harvester's RKE2 cluster kubeconfig file path"
  default     = null
}

variable "kube_config_filename" {
  type        = string
  description = "Harvester's RKE2 cluster kubeconfig file name"
  default     = null
}

variable "create_os_image" {
  default = null
}

# variable "os_image_name" {}

# variable "os_image" {}

# variable "os_image_url" {}

variable "create_secondary_network" {
  default = null
}

# variable "cluster_network_name" {}

# variable "vlan_uplink_nic" {}

variable "vm_count" {}

variable "vm_namespace" {}

# variable "description" {}

variable "ssh_username" {}

variable "ssh_password" {}

# variable "cpu" {}

# variable "memory" {}

# variable "vm_disk_size" {}

# variable "vm_data_disk_size" {}

# variable "startup_script" {}

variable "rke2_version" {
  type        = string
  description = "RKE2 version"
  default     = null
}

variable "rke2_config" {
  description = "Additional customization to the RKE2 config.yaml file"
  default     = null
}
