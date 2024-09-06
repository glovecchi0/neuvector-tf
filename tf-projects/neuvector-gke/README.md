# How to create resources

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `neuvector_password` to change the default admin password
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../tf-modules/google-cloud/README.md).

#### Terraform
```bash
terraform init -upgrade && terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy -auto-approve
```

#### OpenTofu
```bash
tofu init -upgrade &&  tofu apply -auto-approve
```

- Destroy the resources when finished
```bash
tofu destroy -auto-approve
```
