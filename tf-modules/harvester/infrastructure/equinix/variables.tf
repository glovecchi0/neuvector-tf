variable "prefix" {
  description = "The prefix used in front of all Equinix resources"
  type        = string
  default     = "equinix-tf"
}

variable "create_ssh_key_pair" {
  description = "Specify if a new SSH key pair needs to be created for the instances"
  type        = bool
  default     = true
}

variable "ssh_key_pair_name" {
  description = "If you want to use an existing key pair, specify its name"
  type        = string
  default     = null
}

variable "ssh_private_key_path" {
  description = "The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform)"
  type        = string
  default     = null
}

variable "ssh_public_key_path" {
  description = "The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform)"
  type        = string
  default     = null
}

variable "harvester_version" {
  description = "Harvester version to be installed (Must be a valid version tag from https://github.com/rancherlabs/terraform-harvester-equinix/tree/main/ipxe)"
  type        = string
  default     = "v1.3.1"
}

variable "instance_count" {
  description = "Number of nodes to deploy Harvester cluster"
  type        = number
  default     = 3
}

variable "metal_create_project" {
  description = "Create a Metal Project if this is 'true'. Else use provided 'project_name'"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Name of the Equinix Metal project to deploy into, when not looking up by project_id"
  type        = string
  default     = "Harvester Labs"
}

variable "organization_id" {
  description = "Equinix Metal organization ID to create or find a project in"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "Equinix Metal project ID to deploy into, if not creating a new project or looking up by name"
  type        = string
  default     = ""
}

variable "plan" {
  description = "Size of the servers to be deployed on Equinix metal (https://deploy.equinix.com/developers/docs/metal/hardware/standard-servers/)"
  type        = string
  default     = "m3.small.x86"
}

variable "billing_cycle" {
  description = "Equinix metal billing/invoice generation schedule (hourly/daily/monthly/yearly)"
  type        = string
  default     = "hourly"
}

variable "metro" {
  description = "Equinix metal data center location (https://deploy.equinix.com/developers/docs/metal/locations/metros/). Examples: SG,SV,AM,MA,Ny,LA,etc."
  type        = string
  default     = "SG"
}

variable "ipxe_script" {
  description = "URL to the iPXE script to use for booting the server (harvester_version will be appended to this without the 'v' prefix)"
  type        = string
  default     = "https://raw.githubusercontent.com/rancherlabs/terraform-harvester-equinix/main/ipxe/ipxe-"
}

variable "spot_instance" {
  description = "Set to true to use spot instance instead of on demand. Also set your max bid price if true."
  type        = bool
  default     = true
}

variable "max_bid_price" {
  description = "Maximum bid price for spot request"
  type        = string
  default     = "0.75"
}

variable "use_cheapest_metro" {
  description = "A boolean variable to control cheapest metro selection"
  type        = bool
  default     = true
}

variable "ssh_key" {
  description = "Your ssh key, examples: 'github: myghid' or 'ssh-rsa AAAAblahblah== keyname'"
  type        = string
  default     = ""
}

variable "vlan_count" {
  description = "Number of VLANs to be created"
  type        = number
  default     = 2
}

variable "rancher_api_url" {
  description = "Rancher API endpoint to manager your Harvester cluster"
  type        = string
  default     = ""
}

variable "rancher_access_key" {
  description = "Rancher access key"
  type        = string
  default     = ""
}

variable "rancher_secret_key" {
  description = "Rancher secret key"
  type        = string
  default     = ""
}

variable "rancher_insecure" {
  description = "Allow insecure connections to the Rancher API"
  type        = bool
  default     = false
}

variable "api_key" {
  description = "Equinix Metal authentication token. Required when using Spot Instances for HTTP pricing lookups. METAL_AUTH_TOKEN should always be set as an environment variable"
  type        = string
  default     = ""
}
