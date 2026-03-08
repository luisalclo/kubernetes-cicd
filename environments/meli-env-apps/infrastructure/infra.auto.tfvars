# 1. Global Context
gcp = {
  project_id = "meli-firestore"
  region     = "us-central1"
  zone       = "us-central1-c"
}

# 2. Network Config
network = {
  name            = "meli-vpc-test-2"
  subnet_jumpbox  = "meli-subnet-jumpbox"
  cidr_jumpbox    = "192.168.10.0/24"
  subnet_gke      = "meli-subnet-gke-nodes"
  cidr_gke        = "10.0.0.0/24"
  subnet_services = "meli-subnet-lbs"
  cidr_services   = "192.168.20.0/24"
}

# 3. Firewall Constants
firewall = {
  iap_range = ["35.235.240.0/20"] # Google IAP default range
  ssh_port  = ["22"]
}

# 4. Firestore Detailed Config
firestore_config = {
  name             = "meli-firestore-native"
  type             = "FIRESTORE_NATIVE"
  edition          = "ENTERPRISE"
  concurrency      = "PESSIMISTIC"
  app_engine_integ = "DISABLED"
  pitr             = "POINT_IN_TIME_RECOVERY_ENABLED"
  delete_protect   = "DELETE_PROTECTION_DISABLED"
  deletion_policy  = "DELETE"
  app_user         = "mongo-user"
}

 # 5. GKE Cluster Config
gke_config = {
  name              = "meli-gke-standard"
  master_cidr       = "172.16.0.32/28"
  cluster_cidr      = "10.136.0.0/14"
  services_cidr     = "34.118.224.0/20"
  min_version       = "1.33.5-gke.1125000"

  # --- Maintenance ---
  maintenance_start_time = "2023-01-01T06:00:00Z"
  maintenance_end_time   = "2023-01-01T12:00:00Z"
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
  
  # Service Account
  sa_id             = "gke-node-sa"
  sa_display_name   = "GKE Node Service"
  
  # --- Security & Access Control ---
  authorized_cidr         = "172.16.0.0/16" # Example 172.16.0.0/16
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
  node_locations          = ["us-central1-a", "us-central1-b", "us-central1-f"]
  release_channel         = "STABLE"
  logging_service         = "logging.googleapis.com/kubernetes"
  monitoring_service      = "monitoring.googleapis.com/kubernetes"
  
  # Node Pool
  std_pool_name     = "gke-pool-standard"
  std_node_count    = 4
  std_machine_type  = "n1-standard-16"
  std_disk_size     = 100
  std_disk_type     = "pd-balanced"
}

# 6. Jumpbox Config
jumpbox = {
  name         = "jumpbox-admin-vm"
  machine_type = "e2-medium"
  image        = "debian-cloud/debian-12"
  disk_size    = 50
  disk_type    = "pd-balanced"
  sa_id        = "jumpbox-admin-sa"
}

# 7. Storage Buckets (Existing Manual Buckets to retrive json trigger and retrive json payloads)
buckets = {
  config_name = "locust-config"
  data_name   = "meli-json-payloads"
}