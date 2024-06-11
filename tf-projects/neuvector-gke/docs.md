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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_google-kubernetes-engine"></a> [google-kubernetes-engine](#module\_google-kubernetes-engine) | ../../tf-modules/google-cloud/gke | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.neuvector-core](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.first-setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_service.neuvector-service-webui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_neuvector_password"></a> [neuvector\_password](#input\_neuvector\_password) | n/a | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neuvector-webui-url"></a> [neuvector-webui-url](#output\_neuvector-webui-url) | NeuVector WebUI (Console) URL |
