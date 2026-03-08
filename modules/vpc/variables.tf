variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "gcp_region" {
  description = "Google Cloud region for the subnetworks."
  type        = string
  default     = "us-central1"
}

variable "vpc" {
  description = "Configuration object for VPC Network and THREE Subnetworks."
  type = object({
    # --- Global VPC Settings ---
    create                          = bool
    network_name                    = string
    auto_create_subnetworks         = bool

    # --- Subnet 01 Configuration (e.g., Jumpbox) ---
    subnet_01_name                  = string
    subnet_01_cidr                  = string
    subnet_01_private_google_access = bool

    # --- Subnet 02 Configuration (e.g., GKE Nodes) ---
    subnet_02_name                  = string
    subnet_02_cidr                  = string
    subnet_02_private_google_access = bool

    # --- Subnet 03 Configuration (e.g., Load Balancers) ---
    # This is the new block we added
    subnet_03_name                  = string
    subnet_03_cidr                  = string
    subnet_03_private_google_access = bool
  })

  # Default values updated for 3 subnets
  default = {
    create                          = true
    network_name                    = "generic-vpc"
    auto_create_subnetworks         = false

    # Defaults for Subnet 01
    subnet_01_name                  = "subnet-01"
    subnet_01_cidr                  = "10.0.1.0/24"
    subnet_01_private_google_access = true

    # Defaults for Subnet 02
    subnet_02_name                  = "subnet-02"
    subnet_02_cidr                  = "10.0.2.0/24"
    subnet_02_private_google_access = true

    # Defaults for Subnet 03
    subnet_03_name                  = "subnet-03"
    subnet_03_cidr                  = "10.0.3.0/24"
    subnet_03_private_google_access = true
  }
}