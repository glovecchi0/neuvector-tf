## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | 1.36.4 |
| <a name="requirement_harvester"></a> [harvester](#requirement\_harvester) | 0.6.4 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 4.1.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_harvester-additional-virtual-machines"></a> [harvester-additional-virtual-machines](#module\_harvester-additional-virtual-machines) | ../../../tf-modules/harvester/virtual-machines | n/a |
| <a name="module_harvester-equinix"></a> [harvester-equinix](#module\_harvester-equinix) | ../../../tf-modules/harvester/infrastructure/equinix | n/a |
| <a name="module_harvester-first-virtual-machine"></a> [harvester-first-virtual-machine](#module\_harvester-first-virtual-machine) | ../../../tf-modules/harvester/virtual-machines | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.harvester-vms-namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [local_file.kubeconfig-yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rke2-additional-servers-config-yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.rke2-first-server-config-yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.wait-harvester-services-startup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [ssh_resource.retrieve-kubeconfig](https://registry.terraform.io/providers/loafoe/ssh/2.7.0/docs/resources/resource) | resource |
| [local_file.rke2-additional-servers-config-yaml-content](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.rke2-first-server-config-yaml-content](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.ssh-private-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.ssh-public-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_os_image"></a> [create\_os\_image](#input\_create\_os\_image) | n/a | `any` | `null` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Harvester's RKE2 cluster kubeconfig file name | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Harvester's RKE2 cluster kubeconfig file path | `string` | `null` | no |
| <a name="input_metro"></a> [metro](#input\_metro) | n/a | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `any` | n/a | yes |
| <a name="input_rancher_access_key"></a> [rancher\_access\_key](#input\_rancher\_access\_key) | Rancher Access Key | `string` | `""` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | Rancher API endpoint to manager your Harvester cluster | `string` | `""` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Allow or not insecure connections to the Rancher API | `bool` | `false` | no |
| <a name="input_rancher_secret_key"></a> [rancher\_secret\_key](#input\_rancher\_secret\_key) | Rancher Secret Key | `string` | `""` | no |
| <a name="input_rke2_config"></a> [rke2\_config](#input\_rke2\_config) | Additional customization to the RKE2 config.yaml file | `any` | `null` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | RKE2 version | `string` | `null` | no |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | n/a | `any` | n/a | yes |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform) | `any` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | n/a | `any` | n/a | yes |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | n/a | `any` | n/a | yes |
| <a name="input_vm_namespace"></a> [vm\_namespace](#input\_vm\_namespace) | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_equinix_additional_servers_public_ip"></a> [equinix\_additional\_servers\_public\_ip](#output\_equinix\_additional\_servers\_public\_ip) | n/a |
| <a name="output_equinix_first_server_public_ip"></a> [equinix\_first\_server\_public\_ip](#output\_equinix\_first\_server\_public\_ip) | n/a |
| <a name="output_harvester_first_virtual_machine_ip"></a> [harvester\_first\_virtual\_machine\_ip](#output\_harvester\_first\_virtual\_machine\_ip) | n/a |
| <a name="output_harvester_first_virtual_machine_name"></a> [harvester\_first\_virtual\_machine\_name](#output\_harvester\_first\_virtual\_machine\_name) | n/a |
| <a name="output_harvester_url"></a> [harvester\_url](#output\_harvester\_url) | n/a |
