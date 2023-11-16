# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `allowed_ip_cidr_range` to specify which IP addresses will be able to contact the cluster API Server
    -  `aws_region` to suit your region
    -  `neuvector_password` to change the default admin password
- Make sure you are logged into your AWS Account from your local Terminal. See the preparatory steps [here](../../tf-modules/aws/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init --upgrade ; terraform apply -target=module.aws-elastic-kubernetes-service --auto-approve ; terraform apply --auto-approve
```

- Destroy the resources when finished
```bash
sh ./drain-nodes.sh ; terraform destroy --auto-approve
```
