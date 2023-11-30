# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_name` to specify in which Project the resources will be created
    -  `metro` to suit your region
- Make sure you are logged into your Equinix Account from your local Terminal. See the preparatory steps [here](../../../tf-modules/harvester/infrastructure/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init -upgrade ; terraform apply -target=module.harvester-equinix.tls_private_key.ssh_private_key -target=module.harvester-equinix.local_file.private_key_pem -target=module.harvester-equinix.local_file.public_key_pem -auto-approve ; terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy --auto-approve
```

## How to access VMs

#### Add your PUBLIC SSH Key to your Equinix profile (Click at the top right > My Profile > SSH Keys > + Add New Key)

#### Run the following command

```bash
ssh -oStrictHostKeyChecking=no -i <PREFIX>-ssh_private_key.pem rancher@<PUBLIC_IPV4>
```
