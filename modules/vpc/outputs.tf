output "network_name" {
  description = "The name of the VPC network created."
  # Returns the name if created, else null.
  value       = var.vpc.create ? google_compute_network.network[0].name : null
}

output "network_self_link" {
  description = "The URI of the VPC network created."
  value       = var.vpc.create ? google_compute_network.network[0].self_link : null
}

# Output for Subnet 02 Name
output "subnet_02_name" {
  description = "The name of the second subnetwork created."
  value       = var.vpc.create ? google_compute_subnetwork.subnet_02[0].name : null
}

# Output for the Project ID
output "project_id" {
  description = "The Google Cloud project ID where the VPC was created."
  value       = var.project_id
}