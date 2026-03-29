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
  description = "Configuration object for VPC Network and Subnetworks."
  type = object({
    # --- Global VPC Settings ---
    create                          = bool
    network_name                    = string
    auto_create_subnetworks         = bool

    # --- Subnet Configuration (GKE Nodes) ---
    subnet_02_name                  = string
    subnet_02_cidr                  = string
    subnet_02_private_google_access = bool
  })

  default = {
    create                          = true
    network_name                    = "generic-vpc"
    auto_create_subnetworks         = false

    # Defaults for Subnet
    subnet_02_name                  = "subnet-02"
    subnet_02_cidr                  = "10.0.2.0/24"
    subnet_02_private_google_access = true
  }
}