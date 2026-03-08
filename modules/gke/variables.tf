# Meli-TF/terraform/modules/gke/variables.tf

# --- GENERAL & REQUIRED SETTINGS ---

variable "project_id" {
  description = "The GCP project ID where the GKE cluster will be deployed."
  type        = string
}

variable "location" {
  description = "The compute zone or region for the cluster and node pools (e.g., 'us-central1')."
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "my-gke-cluster"
}

variable "maintenance_start_time" {
  type        = string
  description = "Start time for maintenance window (UTC)"
}

variable "maintenance_end_time" {
  type        = string
  description = "End time for maintenance window (UTC)"
}

variable "maintenance_recurrence" {
  type        = string
  description = "Recurrence rule (e.g., FREQ=WEEKLY;BYDAY=SU)"
}

# --- NETWORK SETTINGS (VPC-NATIVE) ---

variable "network_name" {
  description = "The name or self_link of the VPC network."
  type        = string
}

variable "subnetwork_name" {
  description = "The name or self_link of the subnetwork for GKE nodes."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The /28 IP range for the hosted master network (required for private clusters)."
  type        = string
  default     = "172.16.0.0/28"
}

# --- IP ALLOCATION ---

variable "cluster_ipv4_cidr_block" {
  description = "The CIDR range for Kubernetes Pod IP addresses. GKE creates a secondary range using this block (e.g., '10.100.0.0/14')."
  type        = string
  default     = "10.136.0.0/14" 
}

variable "services_ipv4_cidr_block" {
  description = "The CIDR range for Kubernetes Services (ClusterIPs). GKE creates a secondary range using this block (e.g., '10.40.0.0/24')."
  type        = string
  default     = "34.118.224.0/20" 
}

# --- SERVICE ACCOUNT CONFIGURATION ---

variable "service_account_id" {
  description = "The ID for the custom service account assigned to the GKE nodes."
  type        = string
  default     = "gke-node-sa"
}

variable "service_account_display_name" {
  description = "Display name for the custom service account."
  type        = string
  default     = "GKE Node Service Account"
}

variable "oauth_scopes" {
  description = "The list of OAuth scopes for the node service account."
  type        = list(string)
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "enable_secure_boot" {
  description = "Enable Secure Boot for GKE nodes"
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring for GKE nodes"
  type        = bool
  default     = true
}

# --- CLUSTER CONTROL & SECURITY ---

variable "min_master_version" {
  description = "The minimum desired master version (e.g., '1.28')."
  type        = string
  default     = "1.28"
}

variable "deletion_protection" {
  description = "Whether Terraform will be prevented from destroying the cluster."
  type        = bool
  default     = true
}

variable "enable_shielded_nodes" {
  description = "Enable Shielded Nodes features on all nodes in this cluster (security best practice)."
  type        = bool
  default     = true
}


variable "master_authorized_networks_enabled" {
  description = "Whether to enable master authorized networks to restrict access to the control plane."
  type        = bool
  default     = false
}

variable "master_authorized_cidr_blocks" {
  description = "External networks that can access the master (used if master_authorized_networks_enabled = true)."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "release_channel_name" {
  description = "The selected release channel. Recommended values are REGULAR or STABLE."
  type        = string
  default     = "STABLE" 
}

variable "default_max_pods_per_node" {
  description = "Adjust or reduce maximum pods per node"
  type        = number
  default     = 110
}

# --- PRIVATE CLUSTER CONFIG ---

variable "enable_private_nodes" {
  description = "Whether nodes should have private RFC 1918 addresses."
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "When true, disables public endpoint access to the master (only for private clusters)."
  type        = bool
  default     = true
}

# --- NODE POOL MANAGEMENT ---

variable "remove_default_node_pool" {
  description = "Whether to remove the default node pool created by GKE."
  type        = bool
  default     = true
}

variable "initial_node_count" {
  description = "The number of nodes to create in the initial node pool before deletion."
  type        = number
  default     = 1
}

variable "auto_repair_enabled" {
  description = "Whether the nodes in the node pools will be automatically repaired."
  type        = bool
  default     = true
}

variable "auto_upgrade_enabled" {
  description = "Whether the nodes in the node pools will be automatically upgraded."
  type        = bool
  default     = true
}

variable "resource_manager_tags" {
  description = "A map of resource manager tag keys/values applied to the node VMs (drift prevention)."
  type        = map(string)
  default     = {} 
}

variable "storage_pools" {
  description = "The list of Storage Pools where boot disks are provisioned (drift prevention)."
  type        = list(string)
  default     = [] 
}

variable "node_tags" {
  description = "The list of instance tags applied to all nodes (used for firewalls; drift prevention)."
  type        = list(string)
  default     = [] 
}

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes are located (e.g., ['us-central1-a', 'us-central1-c']). Only used for regional clusters."
  type        = list(string)
  default     = [] # Default behavior is to use all zones in the region.
}


# --- OBSERVABILITY ---

variable "logging_service" {
  description = "The logging service (e.g., 'logging.googleapis.com/kubernetes')."
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "The monitoring service (e.g., 'monitoring.googleapis.com/kubernetes')."
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

# --- 3. NODE POOL: STANDARD/RELIABLE ---

variable "standard_node_pool_name" {
  description = "The name of the standard, non-preemptible node pool."
  type        = string
  default     = "gke-standard-pool"
}

variable "standard_node_count" {
  description = "The number of nodes in the standard node pool."
  type        = number
  default     = 3
}

variable "standard_machine_type" {
  description = "The machine type for the standard node pool (e.g., 'e2-medium')."
  type        = string
  default     = "e2-medium"
}

variable "standard_disk_size_gb" {
  description = "Size of the boot disk attached to each node in the standard pool (in GB)."
  type        = number
  default     = 100
}

variable "standard_disk_type" {
  description = "Type of the boot disk attached to each node in the standard pool (e.g., 'pd-balanced', 'pd-ssd')."
  type        = string
  default     = "pd-balanced"
}

# # --- 4. NODE POOL: SPOT/PREEMPTIBLE ---

# variable "spot_node_pool_name" {
#   description = "The name of the spot/preemptible node pool."
#   type        = string
#   default     = "gke-spot-pool"
# }

# variable "spot_node_count" {
#   description = "The number of nodes in the spot/preemptible node pool."
#   type        = number
#   default     = 1
# }

# variable "spot_machine_type" {
#   description = "The machine type for the spot/preemptible node pool (often a smaller type)."
#   type        = string
#   default     = "e2-small"
# }

# variable "spot_disk_size_gb" {
#   description = "Size of the boot disk attached to each node in the standard pool (in GB)."
#   type        = number
#   default     = 100
# }

# variable "spot_disk_type" {
#   description = "Type of the boot disk attached to each node in the standard pool (e.g., 'pd-balanced', 'pd-ssd')."
#   type        = string
#   default     = "pd-balanced"
# }