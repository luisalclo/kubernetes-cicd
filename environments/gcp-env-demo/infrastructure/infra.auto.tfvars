# 1. Global Context
gcp = {
  project_id = "developer-sandbox-489120"
  region     = "us-central1"
  zone       = "us-central1-c"
}

# 2. Network Config
network = {
  name            = "gcp-vpc-demo-gke"
  subnet_gke      = "gcp-subnet-gke-nodes"
  cidr_gke        = "10.0.0.0/24"
}

# 3. Firewall Constants
firewall = {
  iap_range = ["35.235.240.0/20"] # Google IAP default range
  ssh_port  = ["22"]
}

 # 5. GKE Cluster Config
gke_config = {
  name              = "gke-demo-standard" 
  master_cidr       = "172.16.0.32/28"
  cluster_cidr      = "10.136.0.0/14"
  services_cidr     = "34.118.224.0/20"
  min_version       = "1.34.3-gke.1318000"

  # --- Maintenance ---
  maintenance_start_time = "2023-01-01T06:00:00Z"
  maintenance_end_time   = "2023-01-01T12:00:00Z"
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"

  # Service Account
  sa_id             = "gke-node-sa"
  sa_display_name   = "GKE Node Service"

  # --- Security & Access Control ---
  authorized_cidr         = "0.0.0.0/0" # Example 172.16.0.0/16
  auth_cidr_name          = "Allow All (CI/CD Access)"

  # Toggle para Public/Private Endpoint
  enable_private_nodes    = true
  enable_private_endpoint = false
  deletion_protection     = false
  enable_shielded_nodes   = true
  enable_secure_boot      = true
  enable_integrity        = true

  # --- Cluster Ops ---
  remove_default_pool     = true
  initial_node_count      = 1
  node_locations          = ["us-central1-a", "us-central1-b"]
  release_channel         = "STABLE"
  logging_service         = "logging.googleapis.com/kubernetes"
  monitoring_service      = "monitoring.googleapis.com/kubernetes"

  # Node Pool
  std_pool_name     = "pool-standard"
  std_node_count    = 1
  std_machine_type  = "e2-standard-2"
  std_disk_size     = 100
  std_disk_type     = "pd-balanced"
}