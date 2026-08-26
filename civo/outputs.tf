output "instance_ids" {
  description = "The IDs of the runner instances"
  value       = civo_instance.runner[*].id
}

output "public_ips" {
  description = "The public IPs of the runner instances"
  value       = civo_instance.runner[*].public_ip
}
