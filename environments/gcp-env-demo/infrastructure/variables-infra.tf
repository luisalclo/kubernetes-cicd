variable "gcp" {
  description = "Global Google Cloud configuration"
  type = object({
    project_id = string
    region     = string
    zone       = string
  })
}

variable "network" {
  description = "VPC network and subnetwork configurations"
  type = object({
    name            = string
    subnet_jumpbox  = string
    cidr_jumpbox    = string
    subnet_gke      = string
    cidr_gke        = string
    subnet_services = string
    cidr_services   = string
  })
}

variable "firewall" {
  description = "Firewall rules configuration"
  type = object({
    iap_range = list(string) # e.g. ["35.235.240.0/20"]
    ssh_port  = list(string)
  })
}

variable "gke_config" {
  description = "Comprehensive GKE Cluster configuration"
  type = object({
    name                   = string
    master_cidr            = string
    cluster_cidr           = string
    services_cidr          = string
    min_version            = string
    
    # Maintenance
    maintenance_start_time = string 
    maintenance_end_time   = string 
    maintenance_recurrence = string 
    
    # Service Account
    sa_id                  = string
    sa_display_name        = string
    
    # Access & Security
    authorized_cidr        = string
    auth_cidr_name         = string
    enable_private_nodes   = bool
    enable_private_endpoint = bool 
    deletion_protection    = bool
    enable_shielded_nodes  = bool
    enable_secure_boot     = bool
    enable_integrity       = bool

    # Cluster Operations
    remove_default_pool    = bool
    initial_node_count     = number
    node_locations         = list(string)
    release_channel        = string
    logging_service        = string
    monitoring_service     = string
    
    # Standard Pool
    std_pool_name          = string
    std_node_count         = number
    std_machine_type       = string
    std_disk_size          = number
    std_disk_type          = string
  })
}

variable "jumpbox" {
  description = "Jumpbox VM configuration"
  type = object({
    name         = string
    machine_type = string
    image        = string
    disk_size    = number
    disk_type    = string
    sa_id        = string
  })
}
