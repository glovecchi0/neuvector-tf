## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_harvester"></a> [harvester](#requirement\_harvester) | 0.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_harvester"></a> [harvester](#provider\_harvester) | 0.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [harvester_image.image](https://registry.terraform.io/providers/harvester/harvester/0.6.3/docs/resources/image) | resource |
| [harvester_virtualmachine.default](https://registry.terraform.io/providers/harvester/harvester/0.6.3/docs/resources/virtualmachine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cpu"></a> [cpu](#input\_cpu) | VMs CPU | `number` | `2` | no |
| <a name="input_description"></a> [description](#input\_description) | VMs description | `string` | `"Created using Terraform"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | VMs Memory, specified in GB | `number` | `8` | no |
| <a name="input_os_image"></a> [os\_image](#input\_os\_image) | Harvester's VMs OS Image display name | `string` | `"ubuntu-22.04-server-cloudimg-amd64"` | no |
| <a name="input_os_image_name"></a> [os\_image\_name](#input\_os\_image\_name) | Harvester's VMs OS Image name | `string` | `"ubuntu22"` | no |
| <a name="input_os_image_url"></a> [os\_image\_url](#input\_os\_image\_url) | Harvester's VMs OS Image URL | `string` | `"https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Equnix resources | `any` | n/a | yes |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH login | `string` | `"ubuntu"` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | The number of instances | `number` | `3` | no |
| <a name="input_vm_data_disk_size"></a> [vm\_data\_disk\_size](#input\_vm\_data\_disk\_size) | Size of the data disk attached to each VMs, specified in GB | `number` | `10` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Size of the root disk attached to each VMs, specified in GB | `number` | `50` | no |
| <a name="input_vm_namespace"></a> [vm\_namespace](#input\_vm\_namespace) | VMs namespace | `string` | `"default"` | no |

## Outputs

No outputs.
