output "neuvector-webui-url" {
  value       = "https://${data.kubernetes_service.neuvector-service-webui.status.0.load_balancer.0.ingress[0].ip}:8443"
  description = "NeuVector WebUI (Console) URL"
}
