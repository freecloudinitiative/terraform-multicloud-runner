variable "location" {
  type        = string
  description = "The Azure region to deploy resources into"
  default     = "germanywestcentral"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group"
  default     = "runner-azure-rg"
}

variable "instance_name" {
  type        = string
  description = "The prefix name of the runner instance"
  default     = "github-runner-azure"
}

variable "instance_size" {
  type        = string
  description = "The Azure VM size (ARM64 architecture, e.g. Standard_D2ps_v5)"
  default     = "Standard_D2ps_v5"
}

variable "admin_username" {
  type        = string
  description = "The administrator username for the VM"
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "Optional SSH public key string. If empty, a TLS private key is automatically generated."
  default     = ""
}

variable "admin_cidrs" {
  type        = list(string)
  description = "List of trusted CIDRs for SSH access"
  default     = ["0.0.0.0/0"]
}

variable "github_pat" {
  type        = string
  description = "GitHub Personal Access Token for runner registration (needs admin:org or repo scope)"
  sensitive   = true
  default     = ""
}

variable "github_org" {
  type        = string
  description = "GitHub organization to register the runner (e.g. 'freecloudinitiative')"
  default     = "freecloudinitiative"
}

variable "cluster_mode" {
  type        = string
  description = "Cluster mode: 'simple' (2 VMs) or 'HA' (3 VMs)"
  default     = "simple"

  validation {
    condition     = contains(["simple", "HA"], var.cluster_mode)
    error_message = "cluster_mode must be either 'simple' or 'HA'."
  }
}

variable "runners_per_vm" {
  type        = number
  description = "Number of GitHub Actions runner instances to run concurrently per VM"
  default     = 4

  validation {
    condition     = var.runners_per_vm > 0 && floor(var.runners_per_vm) == var.runners_per_vm
    error_message = "runners_per_vm must be a positive integer."
  }
}

variable "simple_node_count" {
  type        = number
  description = "Number of runner VMs when cluster_mode is 'simple'"
  default     = 2
}

variable "ha_node_count" {
  type        = number
  description = "Number of runner VMs when cluster_mode is 'HA'"
  default     = 3
}
