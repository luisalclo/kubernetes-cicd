# ---------------------------------------------------------
# Generic VPC Network Module
# ---------------------------------------------------------

# Core VPC Network Resource
resource "google_compute_network" "network" {
  name                    = var.vpc.network_name
  auto_create_subnetworks = var.vpc.auto_create_subnetworks
  # Create network resources only if the 'create' flag is true.
  count                   = var.vpc.create ? 1 : 0
  project                 = var.project_id
}

# ---------------------------------------------------------
# Subnetwork 1 (e.g., for Jumpbox / General workloads)
# ---------------------------------------------------------
resource "google_compute_subnetwork" "subnet_01" {
  name                     = var.vpc.subnet_01_name
  ip_cidr_range            = var.vpc.subnet_01_cidr
  region                   = var.gcp_region
  # Dynamic reference to the network ID created above.
  network                  = google_compute_network.network[0].id
  count                    = var.vpc.create ? 1 : 0
  project                  = var.project_id
  private_ip_google_access = var.vpc.subnet_01_private_google_access
}

# ---------------------------------------------------------
# Subnetwork 2 (e.g., for GKE Nodes / Databases)
# ---------------------------------------------------------
resource "google_compute_subnetwork" "subnet_02" {
  name                     = var.vpc.subnet_02_name
  ip_cidr_range            = var.vpc.subnet_02_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.network[0].id
  count                    = var.vpc.create ? 1 : 0
  project                  = var.project_id
  private_ip_google_access = var.vpc.subnet_02_private_google_access
}

# ---------------------------------------------------------
# Subnetwork 3 (e.g., for Internal Load Balancers)
# ---------------------------------------------------------
resource "google_compute_subnetwork" "subnet_03" {
  name                     = var.vpc.subnet_03_name
  ip_cidr_range            = var.vpc.subnet_03_cidr
  region                   = var.gcp_region
  network                  = google_compute_network.network[0].id
  count                    = var.vpc.create ? 1 : 0
  project                  = var.project_id
  private_ip_google_access = var.vpc.subnet_03_private_google_access
}

# ---------------------------------------------------------
# Cloud Router (Required for Cloud NAT)
# ---------------------------------------------------------
resource "google_compute_router" "router" {
  name    = "${var.vpc.network_name}-router"
  region  = var.gcp_region
  network = google_compute_network.network[0].id
  project = var.project_id

  count = var.vpc.create ? 1 : 0
}

# ---------------------------------------------------------
# Cloud NAT (Enables Internet access for private VMs)
# ---------------------------------------------------------
resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc.network_name}-nat"
  router                             = google_compute_router.router[0].name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.project_id

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  count = var.vpc.create ? 1 : 0
}