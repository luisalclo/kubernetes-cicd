# Define the required Google Cloud provider for MELI-FIRESTORE GCP Infrastructure

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}