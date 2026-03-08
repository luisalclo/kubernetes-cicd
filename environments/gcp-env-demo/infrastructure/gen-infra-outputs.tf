# ============================================================================
# OUTPUTS
# ============================================================================

# --- VPC NETWORK OUTPUTS ---

output "vpc_network_name" {
  description = "The name of the main VPC network."
  value       = module.vpc_network.network_name
}

output "vpc_subnet_jumpbox_name" {
  description = "The name of the Jumpbox subnetwork (Subnet 01)."
  value       = module.vpc_network.subnet_01_name
}

output "vpc_subnet_gke_nodes_name" {
  description = "The name of the GKE Nodes subnetwork (Subnet 02)."
  value       = module.vpc_network.subnet_02_name
}

output "vpc_subnet_lbs_name" {
  description = "The name of the Load Balancers subnetwork (Subnet 03)."
  value       = module.vpc_network.subnet_03_name # Ensure your VPC module exports this
}


# --- GKE CLUSTER OUTPUTS ---

output "gke_cluster_name" {
  description = "The name of the created GKE cluster."
  value       = module.demo_gkecluster-standard.cluster_name
}

output "gke_standard_pool_name" {
  description = "The name of the standard node pool."
  value       = module.demo_gkecluster-standard.standard_node_pool_name
}

output "gke_cluster_endpoint" {
  description = "The public endpoint of the GKE cluster master."
  # Wrapping the value in nonsensitive() to explicitly allow displaying the IP 
  # in plain text, overriding the module's sensitive marking.
  value       = nonsensitive(module.demo_gkecluster-standard.cluster_endpoint)
}

output "gke_cluster_ca_certificate" {
  description = "The cluster CA certificate (base64)."
  value       = module.demo_gkecluster-standard.cluster_ca_certificate
  sensitive   = true
}

# --- COMPUTE ENGINE OUTPUTS ---

output "jumpbox_ip" {
  description = "The internal IP address of the Jumpbox VM (Private-only)."
  value       = module.vm_instance_module.instance_private_ip 
}