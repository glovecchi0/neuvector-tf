# Terraform CLI - Preparatory steps

Install the Terraform Command Line Interface [(CLI)](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform) to manage infrastructure and interact with Terraform state, providers, configuration files, and Terraform Cloud.

## Example

#### macOS installation and setup

```console
brew tap hashicorp/tap
```

```console 
brew install hashicorp/tap/terraform
```

```console 
brew update
```

```console 
brew upgrade hashicorp/tap/terraform
```

```console
terraform version
```

##### How to enable tab completion

```console 
$ which terraform
  /opt/homebrew/bin/terraform
$ echo "complete -C /opt/homebrew/bin/terraform terraform" >> ~/.bash_profile
$ source ~/.bash_profile
```
