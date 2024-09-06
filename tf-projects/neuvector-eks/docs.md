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
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_elastic_kubernetes_service"></a> [aws\_elastic\_kubernetes\_service](#module\_aws\_elastic\_kubernetes\_service) | ../../tf-modules/aws/eks | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.neuvector_core](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [kubernetes_service.neuvector_service_webui](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip_cidr_range"></a> [allowed\_ip\_cidr\_range](#input\_allowed\_ip\_cidr\_range) | Range of IPs that can reach the cluster API Server | `string` | `"0.0.0.0/0"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to create the resources | `string` | `"eu-west-1"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of instances per Node Group | `number` | `3` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Size of the disk attached to each node, specified in GB | `number` | `"50"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The name of a AWS EC2 machine type | `list(any)` | <pre>[<br>  "t2.xlarge"<br>]</pre> | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kubeconfig | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the GKE cluster | `string` | `null` | no |
| <a name="input_neuvector_password"></a> [neuvector\_password](#input\_neuvector\_password) | Password for the NeuVector admin account | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all AWS resources | `string` | n/a | yes |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | AWS Subnet IDs used for all resources. Must be in at least two different availability zones | `string` | `null` | no |
| <a name="input_subnet_ip_cidr_range"></a> [subnet\_ip\_cidr\_range](#input\_subnet\_ip\_cidr\_range) | List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane | `list(any)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24"<br>]</pre> | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | AWS VPC ID used for all resources | `string` | `null` | no |
| <a name="input_vpc_ip_cidr_range"></a> [vpc\_ip\_cidr\_range](#input\_vpc\_ip\_cidr\_range) | Range of private IPs available for the AWS VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neuvector_password"></a> [neuvector\_password](#output\_neuvector\_password) | NeuVector Initial Custom Password |
| <a name="output_neuvector_webui_url"></a> [neuvector\_webui\_url](#output\_neuvector\_webui\_url) | NeuVector WebUI (Console) URL |
