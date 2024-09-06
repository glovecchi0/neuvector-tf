output "neuvector_webui_url" {
  value       = "https://${data.kubernetes_service.neuvector_service_webui.status.0.load_balancer.0.ingress[0].ip}:8443"
  description = "NeuVector WebUI (Console) URL"
}

output "neuvector_password" {
  description = "NeuVector Initial Custom Password"
  value       = var.neuvector_password
}
