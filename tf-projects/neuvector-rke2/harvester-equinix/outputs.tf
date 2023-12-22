output "harvester_url" {
  value = module.harvester-equinix.harvester_url
}

output "equinix_first_server_public_ip" {
  value = module.harvester-equinix.seed_ip
}

output "equinix_additional_servers_public_ip" {
  value = module.harvester-equinix.join_ips
}

output "equinix_helper_server_public_ip" {
  value = module.harvester-equinix.helper_ip
}

output "harvester_first_virtual_machine_name" {
  value = module.harvester-first-virtual-machine.harvester_first_virtual_machine_name
}

output "harvester_first_virtual_machine_ip" {
  value = module.harvester-first-virtual-machine.harvester_first_virtual_machine_ip
}
