## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_equinix"></a> [equinix](#requirement\_equinix) | 2.4.1 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_equinix"></a> [equinix](#provider\_equinix) | 2.4.1 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 5.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [equinix_metal_device.join](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_device) | resource |
| [equinix_metal_device.seed](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_device) | resource |
| [equinix_metal_ip_attachment.first_address_assignment](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_ip_attachment) | resource |
| [equinix_metal_port_vlan_attachment.vlan_attach_join](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_port_vlan_attachment) | resource |
| [equinix_metal_port_vlan_attachment.vlan_attach_seed](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_port_vlan_attachment) | resource |
| [equinix_metal_project.new_project](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_project) | resource |
| [equinix_metal_reserved_ip_block.harvester_vip](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_reserved_ip_block) | resource |
| [equinix_metal_spot_market_request.join_spot_request](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_spot_market_request) | resource |
| [equinix_metal_spot_market_request.seed_spot_request](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_spot_market_request) | resource |
| [equinix_metal_vlan.vlans](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/resources/metal_vlan) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rancher2_cluster.rancher_cluster](https://registry.terraform.io/providers/rancher/rancher2/5.0.0/docs/resources/cluster) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.ssh_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [equinix_metal_device.join_devices](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/data-sources/metal_device) | data source |
| [equinix_metal_device.seed_device](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/data-sources/metal_device) | data source |
| [equinix_metal_ip_block_ranges.address_block](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/data-sources/metal_ip_block_ranges) | data source |
| [equinix_metal_project.project](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/data-sources/metal_project) | data source |
| [equinix_metal_spot_market_request.join_req](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/data-sources/metal_spot_market_request) | data source |
| [equinix_metal_spot_market_request.seed_req](https://registry.terraform.io/providers/equinix/equinix/2.4.1/docs/data-sources/metal_spot_market_request) | data source |
| [http_http.prices](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | Equinix Metal authentication token. Required when using Spot Instances for HTTP pricing lookups. METAL\_AUTH\_TOKEN should always be set as an environment variable | `string` | `""` | no |
| <a name="input_billing_cycle"></a> [billing\_cycle](#input\_billing\_cycle) | Equinix metal billing/invoice generation schedule (hourly/daily/monthly/yearly) | `string` | `"hourly"` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_harvester_version"></a> [harvester\_version](#input\_harvester\_version) | Harvester version to be installed (Must be a valid version tag from https://github.com/rancherlabs/terraform-harvester-equinix/tree/main/ipxe) | `string` | `"v1.3.1"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of nodes to deploy Harvester cluster | `number` | `3` | no |
| <a name="input_ipxe_script"></a> [ipxe\_script](#input\_ipxe\_script) | URL to the iPXE script to use for booting the server (harvester\_version will be appended to this without the 'v' prefix) | `string` | `"https://raw.githubusercontent.com/rancherlabs/terraform-harvester-equinix/main/ipxe/ipxe-"` | no |
| <a name="input_max_bid_price"></a> [max\_bid\_price](#input\_max\_bid\_price) | Maximum bid price for spot request | `string` | `"0.75"` | no |
| <a name="input_metal_create_project"></a> [metal\_create\_project](#input\_metal\_create\_project) | Create a Metal Project if this is 'true'. Else use provided 'project\_name' | `bool` | `false` | no |
| <a name="input_metro"></a> [metro](#input\_metro) | Equinix metal data center location (https://deploy.equinix.com/developers/docs/metal/locations/metros/). Examples: SG,SV,AM,MA,Ny,LA,etc. | `string` | `"SG"` | no |
| <a name="input_organization_id"></a> [organization\_id](#input\_organization\_id) | Equinix Metal organization ID to create or find a project in | `string` | `""` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | Size of the servers to be deployed on Equinix metal (https://deploy.equinix.com/developers/docs/metal/hardware/standard-servers/) | `string` | `"m3.small.x86"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Equinix resources | `string` | `"equinix-tf"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Equinix Metal project ID to deploy into, if not creating a new project or looking up by name | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the Equinix Metal project to deploy into, when not looking up by project\_id | `string` | `"Harvester Labs"` | no |
| <a name="input_rancher_access_key"></a> [rancher\_access\_key](#input\_rancher\_access\_key) | Rancher access key | `string` | `""` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | Rancher API endpoint to manager your Harvester cluster | `string` | `""` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Allow insecure connections to the Rancher API | `bool` | `false` | no |
| <a name="input_rancher_secret_key"></a> [rancher\_secret\_key](#input\_rancher\_secret\_key) | Rancher secret key | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Set to true to use spot instance instead of on demand. Also set your max bid price if true. | `bool` | `true` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Your ssh key, examples: 'github: myghid' or 'ssh-rsa AAAAblahblah== keyname' | `string` | `""` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | If you want to use an existing key pair, specify its name | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_use_cheapest_metro"></a> [use\_cheapest\_metro](#input\_use\_cheapest\_metro) | A boolean variable to control cheapest metro selection | `bool` | `true` | no |
| <a name="input_vlan_count"></a> [vlan\_count](#input\_vlan\_count) | Number of VLANs to be created | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_harvester_url"></a> [harvester\_url](#output\_harvester\_url) | n/a |
| <a name="output_join_ips"></a> [join\_ips](#output\_join\_ips) | n/a |
| <a name="output_seed_ip"></a> [seed\_ip](#output\_seed\_ip) | n/a |
