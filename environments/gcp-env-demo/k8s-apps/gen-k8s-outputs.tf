# ============================================================================
# APP OUTPUTS (Bookinfo)
# ============================================================================

output "bookinfo_namespace" {
  description = "The namespace where the application resides"
  value       = kubernetes_namespace_v1.bookinfo.metadata[0].name
}

output "productpage_public_ip" {
  description = "The external public IP address of the GCP LoadBalancer"
  value       = kubernetes_service_v1.productpage_svc.status[0].load_balancer[0].ingress[0].ip
}

output "bookinfo_url" {
  description = "Direct URL to access the bookstore in your browser"
  value       = "http://${kubernetes_service_v1.productpage_svc.status[0].load_balancer[0].ingress[0].ip}:9080/productpage"
}
