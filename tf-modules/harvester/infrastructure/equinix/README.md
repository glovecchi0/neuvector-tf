## The modules were generated starting from [this project](https://github.com/rancherlabs/harvester-equinix-terraform)

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | 1.22.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | 1.22.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 3.2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [equinix_metal_device.join](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_device) | resource |
| [equinix_metal_device.seed](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_device) | resource |
| [equinix_metal_device_network_type.join_network_type](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_device_network_type) | resource |
| [equinix_metal_device_network_type.seed_network_type](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_device_network_type) | resource |
| [equinix_metal_ip_attachment.first_address_assignment](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_ip_attachment) | resource |
| [equinix_metal_port_vlan_attachment.vlan_attach_join](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_port_vlan_attachment) | resource |
| [equinix_metal_port_vlan_attachment.vlan_attach_seed](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_port_vlan_attachment) | resource |
| [equinix_metal_reserved_ip_block.harvester_vip](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_reserved_ip_block) | resource |
| [equinix_metal_spot_market_request.join_spot_request](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_spot_market_request) | resource |
| [equinix_metal_spot_market_request.seed_spot_request](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_spot_market_request) | resource |
| [equinix_metal_vlan.vlans](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/resources/metal_vlan) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rancher2_cluster.rancher_cluster](https://registry.terraform.io/providers/rancher/rancher2/3.2.0/docs/resources/cluster) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.ssh_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [equinix_metal_device.join_devices](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/data-sources/metal_device) | data source |
| [equinix_metal_device.seed_device](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/data-sources/metal_device) | data source |
| [equinix_metal_ip_block_ranges.address_block](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/data-sources/metal_ip_block_ranges) | data source |
| [equinix_metal_project.project](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/data-sources/metal_project) | data source |
| [equinix_metal_spot_market_request.join_req](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/data-sources/metal_spot_market_request) | data source |
| [equinix_metal_spot_market_request.seed_req](https://registry.terraform.io/providers/equinix/equinix/1.22.0/docs/data-sources/metal_spot_market_request) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_cycle"></a> [billing\_cycle](#input\_billing\_cycle) | Equinix Billing Cycle mode (monthly or hourly) | `string` | `"hourly"` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_harvester_version"></a> [harvester\_version](#input\_harvester\_version) | Harvester's version | `string` | `"v1.2.1"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of nodes created on Equinix and on which the Harvester hypervisor will be installed | `string` | `"3"` | no |
| <a name="input_ipxe_script"></a> [ipxe\_script](#input\_ipxe\_script) | URL pointing to a hosted iPXE script | `string` | `"https://raw.githubusercontent.com/rancherlabs/harvester-equinix-terraform/main/ipxe/ipxe-"` | no |
| <a name="input_max_bid_price"></a> [max\_bid\_price](#input\_max\_bid\_price) | Maximum bid price for spot request | `string` | `"0.75"` | no |
| <a name="input_metro"></a> [metro](#input\_metro) | Equinix Metro area for the new devices | `string` | `"SV"` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | Equinix Server Type | `string` | `"m3.small.x86"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Equnix resources | `any` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Equinix Project Name | `any` | n/a | yes |
| <a name="input_rancher_access_key"></a> [rancher\_access\_key](#input\_rancher\_access\_key) | Rancher Access Key | `string` | `""` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | Rancher API endpoint to manager your Harvester cluster | `string` | `""` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Allow or not insecure connections to the Rancher API | `bool` | `false` | no |
| <a name="input_rancher_secret_key"></a> [rancher\_secret\_key](#input\_rancher\_secret\_key) | Rancher Secret Key | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Set to true to use spot instance instead of on demand. Also set you max bid price if true | `bool` | `true` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform) | `any` | `null` | no |
| <a name="input_vlan_count"></a> [vlan\_count](#input\_vlan\_count) | Number of VLANs to be created | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_harvester_url"></a> [harvester\_url](#output\_harvester\_url) | n/a |
| <a name="output_join_ips"></a> [join\_ips](#output\_join\_ips) | n/a |
| <a name="output_seed_ip"></a> [seed\_ip](#output\_seed\_ip) | n/a |
