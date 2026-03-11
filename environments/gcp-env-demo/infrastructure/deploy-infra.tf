############# BEGINNING OF GCP INFRASTRUCTURE - LOGICAL LAYER BELOW Test ################

# ============================================================================
# 1. VPC NETWORK MODULE
# ============================================================================

module "vpc_network" {
  source = "../../../modules/vpc"

  # --- Global Settings ---
  project_id = var.gcp.project_id
  gcp_region = var.gcp.region

  # --- VPC Configuration ---
  vpc = {
    create                  = true
    network_name            = var.network.name
    auto_create_subnetworks = false

    # Subnets
    subnet_01_name                  = var.network.subnet_jumpbox
    subnet_01_cidr                  = var.network.cidr_jumpbox
    subnet_01_private_google_access = true

    subnet_02_name                  = var.network.subnet_gke
    subnet_02_cidr                  = var.network.cidr_gke
    subnet_02_private_google_access = true

    subnet_03_name                  = var.network.subnet_services
    subnet_03_cidr                  = var.network.cidr_services
    subnet_03_private_google_access = true
  }
}

# ============================================================================
# FIREWALL RULES
# ============================================================================

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh-ingress"
  network = module.vpc_network.network_name
  project = var.gcp.project_id

  allow {
    protocol = "tcp"
    ports    = var.firewall.ssh_port
  }

  # Source ranges defined in tfvars (Google IAP)
  source_ranges = var.firewall.iap_range
  target_tags   = ["jumpbox"]
}

# ============================================================================
# 3. GKE CLUSTER MODULE (Standard)
# ============================================================================

module "demo_gkecluster-standard" {
  source = "../../../modules/gke"

  project_id   = var.gcp.project_id
  cluster_name = var.gke_config.name
  location     = var.gcp.region

  # --- Network Integration - Resources---
  network_name    = module.vpc_network.network_name
  subnetwork_name = module.vpc_network.subnet_02_name

  # --- IP Allocation ---
  master_ipv4_cidr_block   = var.gke_config.master_cidr
  cluster_ipv4_cidr_block  = var.gke_config.cluster_cidr
  services_ipv4_cidr_block = var.gke_config.services_cidr

  # --- Maintenance Policy ---
  maintenance_start_time = var.gke_config.maintenance_start_time
  maintenance_end_time   = var.gke_config.maintenance_end_time 
  maintenance_recurrence = var.gke_config.maintenance_recurrence

  # --- Service Account ---
  service_account_id           = var.gke_config.sa_id
  service_account_display_name = var.gke_config.sa_display_name
  oauth_scopes                 = ["https://www.googleapis.com/auth/cloud-platform"]

  # --- Maintenance Ops ---
  auto_repair_enabled  = true
  auto_upgrade_enabled = true

  # --- STANDARD Node Pool Configuration ---
  standard_node_pool_name = var.gke_config.std_pool_name
  standard_node_count     = var.gke_config.std_node_count
  standard_machine_type   = var.gke_config.std_machine_type
  standard_disk_size_gb   = var.gke_config.std_disk_size
  standard_disk_type      = var.gke_config.std_disk_type

  # --- Security & Access (Fully Parametrized) ---
  min_master_version          = var.gke_config.min_version
  deletion_protection         = var.gke_config.deletion_protection
  
  enable_shielded_nodes       = var.gke_config.enable_shielded_nodes
  enable_secure_boot          = var.gke_config.enable_secure_boot
  enable_integrity_monitoring = var.gke_config.enable_integrity

  enable_private_nodes    = var.gke_config.enable_private_nodes
  enable_private_endpoint = var.gke_config.enable_private_endpoint
  
  master_authorized_networks_enabled = true
  master_authorized_cidr_blocks = [
    {
      cidr_block   = var.gke_config.authorized_cidr
      display_name = var.gke_config.auth_cidr_name
    }
  ]

  # --- Cluster Operations ---
  remove_default_node_pool = var.gke_config.remove_default_pool
  initial_node_count       = var.gke_config.initial_node_count
  node_locations           = var.gke_config.node_locations
  release_channel_name     = var.gke_config.release_channel
  
  logging_service    = var.gke_config.logging_service
  monitoring_service = var.gke_config.monitoring_service

  resource_manager_tags = {}
  storage_pools         = []
  node_tags             = []
  
  depends_on = [module.vpc_network]
}

# ============================================================================
# IAM PERMISSIONS (GKE Nodes Access to Artifact Registry)
# ============================================================================

resource "google_project_iam_member" "gke_nodes_artifact_registry" {
  project = var.gcp.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${module.demo_gkecluster-standard.service_account_email}"
}

############# END OF GCP INFRASTRUCTURE - LOGICAL LAYER ABOVE ################