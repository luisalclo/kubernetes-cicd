output "instance_private_ip" {
  description = "The internal IP address assigned to the VM instance (private access only)."
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "service_account_email" {
  description = "The email address of the Service Account created for the Jumpbox VM."
  # Required for granting IAM permissions (e.g. GKE access) in the root module.
  value       = google_service_account.jumpbox_sa.email
}