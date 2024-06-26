variable "prefix" {
  description = "The prefix used in front of all Equnix resources"
}

variable "project_name" {
  description = "Equinix Project Name"
}

variable "metro" {
  description = "Equinix Metro area for the new devices"
  default     = "SV"
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = true
}

variable "ssh_private_key_path" {
  type        = string
  description = "The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform)"
  default     = null
}

variable "ssh_public_key_path" {
  description = "The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform)"
  default     = null
}

variable "ipxe_script" {
  description = "URL pointing to a hosted iPXE script"
  default     = "https://raw.githubusercontent.com/rancherlabs/harvester-equinix-terraform/main/ipxe/ipxe-"
}

variable "vlan_count" {
  description = "Number of VLANs to be created"
  default     = 1
}

variable "instance_count" {
  description = "The number of nodes created on Equinix and on which the Harvester hypervisor will be installed"
  default     = "3"
}

variable "plan" {
  description = "Equinix Server Type"
  default     = "m3.small.x86"
}

variable "billing_cycle" {
  description = "Equinix Billing Cycle mode (monthly or hourly)"
  default     = "hourly"
}

variable "spot_instance" {
  description = "Set to true to use spot instance instead of on demand. Also set you max bid price if true"
  default     = true
}

variable "max_bid_price" {
  description = "Maximum bid price for spot request"
  default     = "0.75"
}

variable "harvester_version" {
  description = "Harvester's version"
  default     = "v1.3.0"
}

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
