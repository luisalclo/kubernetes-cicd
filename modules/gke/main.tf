# GKE Cluster and Node Pool Configuration

# 1. Resource: Custom Service Account for Nodes
resource "google_service_account" "default" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = var.project_id
}

# 2. Resource: GKE Cluster
resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location
  
  # --- NETWORK CONFIGURATION (VPC-NATIVE) ---
  network    = var.network_name
  subnetwork = var.subnetwork_name
  networking_mode = "VPC_NATIVE"

  # --- NEW: IP ALLOCATION POLICY ---
  ip_allocation_policy {
    
    cluster_ipv4_cidr_block = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block      = var.services_ipv4_cidr_block
  }
  # ---------------------------------

  # --- NEW: RELEASE CHANNEL CONFIGURATION ---
  release_channel {
    channel = var.release_channel_name
  }
  # ------------------------------------------

  # MAINTENANCE POLICY
  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start_time
      end_time   = var.maintenance_end_time
      recurrence = var.maintenance_recurrence
    }
  }
  
  # --- CLUSTER CONTROL AND SECURITY ---
  min_master_version        = var.min_master_version
  deletion_protection       = var.deletion_protection

  node_locations            = var.node_locations
  default_max_pods_per_node = var.default_max_pods_per_node
  
  # FIX: Removed ternary logic for Autopilot conflict resolution.
  enable_shielded_nodes    = var.enable_shielded_nodes 
  remove_default_node_pool = var.remove_default_node_pool
  
  initial_node_count       = var.initial_node_count

  node_config {
    shielded_instance_config {
      enable_secure_boot = true
      enable_integrity_monitoring = true
    }
    service_account = google_service_account.default.email 
    oauth_scopes    = var.oauth_scopes
  }
  
  # Optional: Master Authorized Networks
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks_enabled ? var.master_authorized_cidr_blocks : []
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  # Optional: Private Cluster Configuration
  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # --- OBSERVABILITY ---
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
}

# 3. Resource: Separate Node Pool (STANDARD/Reliable Nodes)
resource "google_container_node_pool" "standard_nodes" {

  # Variables for the STANDARD pool
  name       = var.standard_node_pool_name
  location   = var.location
  project    = var.project_id
  cluster    = google_container_cluster.primary.name
  node_count = var.standard_node_count

  # Management (Auto Repair/Upgrade) is the same for both pools
  management {
    auto_repair  = var.auto_repair_enabled
    auto_upgrade = var.auto_upgrade_enabled
  }

  node_config {
    preemptible  = false # HARDCODED: Standard nodes are NOT preemptible
    machine_type = var.standard_machine_type # Specific machine type for standard nodes

    disk_size_gb = var.standard_disk_size_gb
    disk_type    = var.standard_disk_type
    
    service_account = google_service_account.default.email
    oauth_scopes    = var.oauth_scopes

    shielded_instance_config {
      enable_secure_boot           = var.enable_secure_boot
      enable_integrity_monitoring  = var.enable_integrity_monitoring
    }
    
    # --- ADDED: DRIFT PREVENTION VARIABLES ---
    resource_manager_tags = var.resource_manager_tags
    storage_pools         = var.storage_pools
    tags                  = var.node_tags
    # ----------------------------------------
  }

  lifecycle {
    ignore_changes = [
      node_config[0].resource_manager_tags
    ]
  }
}


# # 4. Resource: Separate Node Pool (SPOT/Preemptible Nodes)
# resource "google_container_node_pool" "spot_nodes" {

#   # Variables for the SPOT pool
#   name       = var.spot_node_pool_name
#   location   = var.location
#   project    = var.project_id
#   cluster    = google_container_cluster.primary.name
#   node_count = var.spot_node_count

#   # Management (Auto Repair/Upgrade)
#   management {
#     auto_repair  = var.auto_repair_enabled
#     auto_upgrade = var.auto_upgrade_enabled
#   }

#   node_config {
#     preemptible  = true # HARDCODED: Spot nodes are always preemptible
#     machine_type = var.spot_machine_type # Specific machine type for spot nodes

#     disk_size_gb = var.spot_disk_size_gb
#     disk_type    = var.spot_disk_type
    
#     service_account = google_service_account.default.email
#     oauth_scopes    = var.oauth_scopes

#     shielded_instance_config {
#       enable_secure_boot           = var.enable_secure_boot
#       enable_integrity_monitoring  = var.enable_integrity_monitoring
#     }

#     # --- ADDED: DRIFT PREVENTION VARIABLES ---
#     resource_manager_tags = var.resource_manager_tags
#     storage_pools         = var.storage_pools
#     tags                  = var.node_tags
#     # ----------------------------------------
#   }
# }