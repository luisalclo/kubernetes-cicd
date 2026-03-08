## JUMPBOX and other related tools VM COMPUTE ENGINE

# 1. Resource: Custom Service Account for Jumpbox
resource "google_service_account" "jumpbox_sa" {
  account_id   = var.jumpbox_sa_id
  display_name = "Jumpbox Service Account for ${var.instance_name}"
  project      = var.project_id
}


# 2. Resource: VM Instance
resource "google_compute_instance" "vm_instance" {
  # --- General Configuration ---
  project      = var.project_id
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  # --- Boot Disk Configuration ---
  boot_disk {
    initialize_params {
      # Use a common base image (Debian 11)
      image = var.boot_image
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  # --- Network Interface ---
  network_interface {
    # Connects to the specified network and subnetwork
    network            = var.network_name
    subnetwork         = var.subnetwork_name
    subnetwork_project = var.subnetwork_project
    
    # --- CONDITIONAL PUBLIC IP ASSIGNMENT ---
    # The 'access_config' block is only built if 'assign_public_ip' is TRUE.
    dynamic "access_config" {
      for_each = var.assign_public_ip ? [1] : []
      content {
        # Empty block requests an ephemeral public IP.
      }
    }
    # ---------------------------------------------
  }

  # --- Service Account (Roles and Scopes) ---
  service_account {
    # Reference the email of the newly created SA (jumpbox_sa)
    email  = google_service_account.jumpbox_sa.email # REFERENCES INTERNAL SA
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  
  shielded_instance_config {
    enable_secure_boot            = var.enable_secure_boot
    enable_vtpm                   = var.enable_vtpm
    enable_integrity_monitoring   = var.enable_integrity_monitoring
  }

  metadata = {
    enable-oslogin = var.enable-oslogin
  }

  tags = var.tags
}