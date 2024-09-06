## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 5.33.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google_kubernetes_engine"></a> [google\_kubernetes\_engine](#module\_google\_kubernetes\_engine) | ../../tf-modules/google-cloud/gke | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.neuvector_core](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.first_setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_service.neuvector_service_webui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_version_prefix"></a> [cluster\_version\_prefix](#input\_cluster\_version\_prefix) | Supported Google Kubernetes Engine for Rancher Manager | `string` | `"1.28."` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced') | `string` | `"pd-balanced"` | no |
| <a name="input_image_type"></a> [image\_type](#input\_image\_type) | The default image type used by NAP once a new node pool is being created. The value must be one of the [COS\_CONTAINERD, COS, UBUNTU\_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24 | `string` | `"cos_containerd"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of nodes per instance group | `number` | `1` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Size of the disk attached to each node, specified in GB | `number` | `50` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The name of a Google Compute Engine machine type | `string` | `"e2-highmem-2"` | no |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | Range of private IPs available for the Google Subnet | `string` | `"10.10.0.0/24"` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kubeconfig | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the GKE cluster | `string` | `null` | no |
| <a name="input_neuvector_password"></a> [neuvector\_password](#input\_neuvector\_password) | Password for the NeuVector admin account | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Google resources | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the Google Project that will contain all created resources | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google Region to create the resources | `string` | `"us-west2"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Google Subnet used for all resources | `string` | `null` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | Google VPC used for all resources | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neuvector_webui_url"></a> [neuvector\_webui\_url](#output\_neuvector\_webui\_url) | NeuVector WebUI (Console) URL |
