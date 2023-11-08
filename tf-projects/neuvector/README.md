# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `neuvector_password` to change the default admin password
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../tf-modules/google-cloud/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init --upgrade ; terraform apply -target=module.google-kubernetes-engine --auto-approve ; terraform apply --auto-approve
```

- Destroy the resources when finished
```bash
terraform state rm module.google-kubernetes-engine.local_file.kube-config-export ; terraform destroy -target=module.google-kubernetes-engine --auto-approve ; terraform destroy --auto-approve
```
