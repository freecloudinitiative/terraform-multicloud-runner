output "instance_ids" {
  description = "The IDs of the Azure runner virtual machines"
  value       = azurerm_linux_virtual_machine.runner[*].id
}

output "public_ips" {
  description = "The public IP addresses of the Azure runner virtual machines"
  value       = azurerm_public_ip.pip[*].ip_address
}

output "tls_private_key" {
  description = "The generated private key if no SSH key was provided (sensitive)"
  value       = length(tls_private_key.ssh) > 0 ? tls_private_key.ssh[0].private_key_pem : null
  sensitive   = true
}
