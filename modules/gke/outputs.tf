# Meli-TF/terraform/modules/gke/outputs.tf

# --- Cluster Connection and Authentication ---

output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "The public endpoint IP address of the cluster master."
  value       = google_container_cluster.primary.endpoint
  sensitive   = true # Security sensitive: The IP address
}

output "cluster_ca_certificate" {
  description = "The base64 encoded cluster CA certificate for authentication."
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true # Security sensitive: The certificate
}

# --- Outputs Node Pools Details ---

output "standard_node_pool_name" {
  description = "The name of the standard, reliable node pool."
  # Uses the 'one' function to safely access the single instance (count=1)
  value       = one(google_container_node_pool.standard_nodes[*].name)
}

# output "spot_node_pool_name" {
#   description = "The name of the preemptible (spot) node pool."
#   # Uses the 'one' function to safely access the single instance (count=1)
#   value       = one(google_container_node_pool.spot_nodes[*].name)
# }

output "service_account_email" {
  description = "The email address of the custom Service Account created for GKE nodes."
  # This is required to grant permissions (like Artifact Registry Reader) in the root module.
  value       = google_service_account.default.email
}