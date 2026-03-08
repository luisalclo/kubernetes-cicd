variable "project_id" {
  description = "The GCP project ID where the VM instance will be deployed."
  type        = string
}

variable "instance_name" {
  description = "The name for the Compute Engine instance."
  type        = string
  default     = "my-web-vm"
}

variable "region" {
  description = "The region where the VM instance will be created (e.g., 'us-central1')."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone where the VM instance will be created (e.g., 'us-central1-a')."
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "The machine type for the instance (e.g., 'e2-medium')."
  type        = string
  default     = "e2-medium"
}

# --- Disk Configuration ---

variable "boot_image" {
  description = "The source image used for the boot disk."
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "disk_size_gb" {
  description = "The size of the primary boot disk in gigabytes."
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "The type of disk (e.g., 'pd-balanced', 'pd-ssd', or 'pd-standard')."
  type        = string
  default     = "pd-balanced"
}

# --- Network Configuration ---

variable "network_name" {
  description = "The name of the network within the VPC network."
  type        = string
  default     = "default"
}

variable "subnetwork_name" {
  description = "The name of the subnetwork within the VPC network."
  type        = string
  default     = "default"
}

variable "subnetwork_project" {
  description = "The ID of the subnetwork project within the VPC network."
  type        = string
  default     = "default"
}

# --- SERVICE ACCOUNT (New Variables) ---

variable "jumpbox_sa_id" {
  description = "The ID (short name) for the custom Service Account created for the VM."
  type        = string
  default     = "jumpbox-sa"
}

# --- Control Flag ---

variable "assign_public_ip" {
  description = "Set to true to assign an ephemeral public IP address to the VM."
  type        = bool
  default     = false 
}

# ------- Shielded_instance_config variables #####

variable "enable_secure_boot" {
  description = "Enable Secure Boot"
  type        = bool
  default     = true 
}

variable "enable_vtpm" {
  description = "Enable VTPM"
  type        = bool
  default     = true 
}

variable "enable_integrity_monitoring" {
  description = "Enable integrity monitoring"
  type        = bool
  default     = true 
}

# ------- METADATA and TAGS #####

variable "enable-oslogin" {
  description = "Enable OS LOGIN"
  type        = bool
  default     = true 
}

variable "tags" {
  description = "Tags for the VM Server"
  type        = list(string)
  default     = ["jumpbox", "internal-only"]
}