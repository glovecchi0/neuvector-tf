## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | ~> 2.3.2 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-elastic-kubernetes-service"></a> [aws-elastic-kubernetes-service](#module\_aws-elastic-kubernetes-service) | ../../tf-modules/aws/eks | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.neuvector-core](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.first-setup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_service.neuvector-service-webui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip_cidr_range"></a> [allowed\_ip\_cidr\_range](#input\_allowed\_ip\_cidr\_range) | n/a | `any` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `any` | n/a | yes |
| <a name="input_neuvector_password"></a> [neuvector\_password](#input\_neuvector\_password) | n/a | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neuvector-webui-url"></a> [neuvector-webui-url](#output\_neuvector-webui-url) | NeuVector WebUI (Console) URL |
