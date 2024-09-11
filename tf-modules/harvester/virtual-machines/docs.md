## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_harvester"></a> [harvester](#requirement\_harvester) | 0.6.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_harvester"></a> [harvester](#provider\_harvester) | 0.6.4 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [harvester_image.image](https://registry.terraform.io/providers/harvester/harvester/0.6.4/docs/resources/image) | resource |
| [harvester_virtualmachine.default](https://registry.terraform.io/providers/harvester/harvester/0.6.4/docs/resources/virtualmachine) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cpu"></a> [cpu](#input\_cpu) | VMs CPU | `number` | `8` | no |
| <a name="input_create_os_image"></a> [create\_os\_image](#input\_create\_os\_image) | Harvester's VMs Image | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | VMs description | `string` | `"Created using Terraform"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | VMs Memory, specified in GB | `number` | `16` | no |
| <a name="input_os_image"></a> [os\_image](#input\_os\_image) | Harvester's VMs OS Image display name | `string` | `"ubuntu-22.04-server-cloudimg-amd64"` | no |
| <a name="input_os_image_name"></a> [os\_image\_name](#input\_os\_image\_name) | Harvester's VMs OS Image name | `string` | `"ubuntu22"` | no |
| <a name="input_os_image_url"></a> [os\_image\_url](#input\_os\_image\_url) | Harvester's VMs OS Image URL | `string` | `"https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Equinix resources | `string` | `"equinix-vm-tf"` | no |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | Password used for SSH login | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH login | `string` | `"ubuntu"` | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Custom startup script | `string` | `null` | no |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | The number of instances | `number` | `3` | no |
| <a name="input_vm_data_disk_size"></a> [vm\_data\_disk\_size](#input\_vm\_data\_disk\_size) | Size of the data disk attached to each VMs, specified in GB | `number` | `10` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Size of the root disk attached to each VMs, specified in GB | `number` | `50` | no |
| <a name="input_vm_namespace"></a> [vm\_namespace](#input\_vm\_namespace) | VMs namespace | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_harvester_first_virtual_machine_ip"></a> [harvester\_first\_virtual\_machine\_ip](#output\_harvester\_first\_virtual\_machine\_ip) | n/a |
| <a name="output_harvester_first_virtual_machine_name"></a> [harvester\_first\_virtual\_machine\_name](#output\_harvester\_first\_virtual\_machine\_name) | n/a |
