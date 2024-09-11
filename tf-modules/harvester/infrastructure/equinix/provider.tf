terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "2.4.1"
    }

    rancher2 = {
      source  = "rancher/rancher2"
      version = "5.0.0"
    }
  }
}

#https://stackoverflow.com/questions/75457176/terraform-child-module-does-not-inherit-provider-from-root-module
#https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841
