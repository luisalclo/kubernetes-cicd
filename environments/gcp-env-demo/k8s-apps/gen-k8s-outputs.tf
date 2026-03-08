# --- GKE(K8S) LOCUST and GRAFANA ENDPOINTS ---

# --- LOCUST (Load Testing) ---
output "locust_web_ui" {
  description = "Public URL for Locust Web Interface"
  value       = "http://${kubernetes_service.locust_master_public.status.0.load_balancer.0.ingress.0.ip}:8089"
}

# --- GRAFANA (Monitoring) ---
output "grafana_web_url" {
  description = "Public URL for Grafana Dashboard"
  value       = "http://${kubernetes_service.grafana_web.status.0.load_balancer.0.ingress.0.ip}"
}