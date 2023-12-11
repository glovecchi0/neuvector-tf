output "harvester_first_server_name" {
  value = resource.harvester_virtualmachine.default.0.name
}
