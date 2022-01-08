output "fcos_public_ip" {
  description = "Public IP of our FCOS instance"
  value = google_compute_instance.fcos_next.network_interface.0.access_config.0.nat_ip
}
