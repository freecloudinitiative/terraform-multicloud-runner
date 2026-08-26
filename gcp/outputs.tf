output "external_ips" {
  description = "Public IP addresses for GCP runner instances"
  value = {
    for name, instance in google_compute_instance.runner : name => instance.network_interface[0].access_config[0].nat_ip
  }
}

output "instance_names" {
  description = "Names of the GCP runner instances"
  value = {
    for name, instance in google_compute_instance.runner : name => instance.name
  }
}
