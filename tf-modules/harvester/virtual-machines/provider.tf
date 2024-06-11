terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.4"
    }
  }
}

#https://stackoverflow.com/questions/75457176/terraform-child-module-does-not-inherit-provider-from-root-module
#https://discuss.hashicorp.com/t/using-a-non-hashicorp-provider-in-a-module/21841
