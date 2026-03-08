# Define the required Google Cloud provider for DEMO GCP Infrastructure

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}