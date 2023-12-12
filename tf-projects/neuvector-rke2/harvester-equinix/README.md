# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_name` to specify in which Project the resources will be created
    -  `metro` to suit your Region
    -  `vm_count` to specify the number of VMs to create
    -  `vm_namespace` to specify the namespace where the VMs will be placed
    -  `ssh_username` to specify the username used for SSH login
    -  `ssh_password` to specify the password used for SSH login
- Make sure you are logged into your Equinix Account from your local Terminal. See the preparatory steps [here](../../../tf-modules/harvester/infrastructure/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init -upgrade ; terraform apply -target=module.harvester-equinix.tls_private_key.ssh_private_key -target=module.harvester-equinix.local_file.private_key_pem -target=module.harvester-equinix.local_file.public_key_pem -auto-approve ; terraform apply -target=module.harvester-equinix -target=null_resource.wait-harvester-services-startup -auto-approve ; terraform apply -target=local_file.ssh-private-key -target=ssh_resource.retrieve-kubeconfig -target=local_file.kubeconfig-yaml -auto-approve ; terraform apply -target=module.harvester-first-virtual-machine.harvester_image.image -auto-approve ; terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy -target=module.harvester-first-virtual-machine -target=module.harvester-additional-virtual-machines -auto-approve ; terraform destroy -auto-approve
```

## How to access Equinix instances

#### Add your PUBLIC SSH Key to your Equinix profile (Click at the top right > My Profile > SSH Keys > + Add New Key)

#### Run the following command

```bash
ssh -oStrictHostKeyChecking=no -i <PREFIX>-ssh_private_key.pem rancher@<PUBLIC_IPV4>
```

# How to access Harvester VMs

#### Install virtctl

##### macOS installation and setup

```bash
export VERSION=v0.54.0
wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-darwin-amd64
mv virtctl-v0.54.0-darwin-amd64 virtctl
chmod +x virtctl
sudo mv virtctl /usr/local/bin/
virtctl version
```

#### Run the following command

```bash
virtctl ssh --local-ssh=true <SSH_USERNAME>@vmi/<VM_NAME>.<VM_NAMESPACE>
```
