variable "prefix" {
  description = "The prefix used in front of all Google resources"
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Project that will contain all created resources"
  type        = string
}

variable "region" {
  description = "Google Region to create the resources"
  type        = string
  default     = "us-west2"

  validation {
    condition = contains([
      "asia-east1",
      "asia-east2",
      "asia-northeast1",
      "asia-northeast2",
      "asia-northeast3",
      "asia-south1",
      "asia-south2",
      "asia-southeast1",
      "asia-southeast2",
      "australia-southeast1",
      "australia-southeast2",
      "europe-central2",
      "europe-north1",
      "europe-southwest1",
      "europe-west1",
      "europe-west10",
      "europe-west12",
      "europe-west2",
      "europe-west3",
      "europe-west4",
      "europe-west6",
      "europe-west8",
      "europe-west9",
      "me-central1",
      "me-central2",
      "me-west1",
      "northamerica-northeast1",
      "northamerica-northeast2",
      "southamerica-east1",
      "southamerica-west1",
      "us-central1",
      "us-east1",
      "us-east4",
      "us-east5",
      "us-south1",
      "us-west1",
      "us-west2",
      "us-west3",
      "us-west4",
    ], var.region)
    error_message = "Invalid Region specified!"
  }
}

variable "ip_cidr_range" {
  description = "Range of private IPs available for the Google Subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "vpc" {
  description = "Google VPC used for all resources"
  type        = string
  default     = null
}

variable "subnet" {
  description = "Google Subnet used for all resources"
  type        = string
  default     = null
}

variable "cluster_version_prefix" {
  description = "Supported Google Kubernetes Engine for Rancher Manager"
  type        = string
  default     = "1.28."
}

variable "instance_count" {
  description = "The number of nodes per instance group"
  type        = number
  default     = 1
}

variable "instance_disk_size" {
  description = "Size of the disk attached to each node, specified in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced')"
  type        = string
  default     = "pd-balanced"
}

variable "image_type" {
  description = "The default image type used by NAP once a new node pool is being created. The value must be one of the [COS_CONTAINERD, COS, UBUNTU_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24"
  type        = string
  default     = "cos_containerd"
}

variable "instance_type" {
  description = "The name of a Google Compute Engine machine type"
  type        = string
  default     = "e2-highmem-2"
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the GKE cluster"
  type        = string
  default     = null
}

variable "kube_config_filename" {
  description = "Filename to write the kubeconfig"
  type        = string
  default     = null
}

variable "neuvector_password" {
  description = "Password for the NeuVector admin account"
}
