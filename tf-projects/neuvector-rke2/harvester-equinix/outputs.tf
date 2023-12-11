output "harvester_url" {
  value = module.harvester-equinix.harvester_url
}

output "harvester_first_server_public_ip" {
  value = module.harvester-equinix.seed_ip
}

output "harvester_additional_servers_public_ip" {
  value = module.harvester-equinix.join_ips
}

output "harvester_first_server_name" {
  value = module.harvester-first-virtual-machine.harvester_first_server_name
}
