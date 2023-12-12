output "harvester_first_virtual_machine_name" {
  value = resource.harvester_virtualmachine.default.0.name
}

output "harvester_first_virtual_machine_ip" {
  value = resource.harvester_virtualmachine.default.0.network_interface[0].ip_address
}
