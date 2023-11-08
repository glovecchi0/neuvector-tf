resource "google_compute_network" "vpc" {
  count                   = var.vpc == null ? 1 : 0
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  count         = var.subnet == null ? 1 : 0
  name          = "${var.prefix}-subnet"
  region        = var.region
  network       = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
  ip_cidr_range = var.ip_cidr_range
}

resource "google_container_cluster" "primary" {
  name     = "${var.prefix}-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  #  min_master_version = var.cluster_version

  network    = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
  subnetwork = var.subnet == null ? resource.google_compute_subnetwork.subnet[0].name : var.subnet

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name

  #  version    = var.cluster_version
  node_count = var.instance_count

  node_config {
    disk_size_gb = var.instance_disk_size
    disk_type    = var.disk_type
    image_type   = var.image_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]

    machine_type = var.instance_type
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "local_file" "kube-config-export" {
  content = templatefile("${path.module}/template-kube_config.yml", {
    cluster_name    = google_container_cluster.primary.name,
    endpoint        = google_container_cluster.primary.endpoint,
    cluster_ca      = google_container_cluster.primary.master_auth.0.cluster_ca_certificate,
    client_cert     = google_container_cluster.primary.master_auth.0.client_certificate,
    client_cert_key = google_container_cluster.primary.master_auth.0.client_key
  })
  file_permission = "0600"
  filename        = "${path.cwd}/${var.prefix}_kube_config.yml"
}
