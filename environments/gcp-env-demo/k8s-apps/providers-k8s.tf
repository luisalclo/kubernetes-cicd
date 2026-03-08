# ============================================================================
# VERSIONS SETUP 
# ============================================================================
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}

# ============================================================================
# 1. CONNECTING TO THE INFRASTRUCTURE LAYER
# ============================================================================
data "terraform_remote_state" "infra" {
  backend = "gcs"
  config = {
    bucket = var.remote_state.bucket
    prefix = var.remote_state.prefix
  }
}

# ============================================================================
# 2. AUTHENTICATION SETTINGS
# ============================================================================
data "google_client_config" "default" {}

# ============================================================================
# 3. KUBERNETES PROVIDER
# ============================================================================
provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.infra.outputs.gke_cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.infra.outputs.gke_cluster_ca_certificate)
}

# ============================================================================
# 4. GOOGLE PROVIDER (Required to read from Secret Manager)
# ============================================================================
provider "google" {
  project = var.gcp.project_id
  region  = var.gcp.region
}