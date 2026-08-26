variable "region" {
  type        = string
  description = "The Civo region to deploy to"
  default     = "FRA1"
}

variable "instance_name" {
  type        = string
  description = "The name of the runner instance"
  default     = "github-runner-civo"
}

variable "instance_size" {
  type        = string
  description = "The size of the instance. Change to Civo's specific ARM instance size if applicable."
  default     = "g4s.large"
}

variable "network_id" {
  type        = string
  description = "The ID of the network to deploy into. Leaves default if empty."
  default     = ""
}

variable "admin_cidrs" {
  type        = list(string)
  description = "List of trusted CIDRs for SSH access. Defaults to everywhere (0.0.0.0/0) but should be restricted."
  default     = ["0.0.0.0/0"]
}

variable "github_pat" {
  type        = string
  description = "GitHub Personal Access Token for runner registration (needs repo scope)"
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
  description = "Cluster mode: 'simple' or 'HA'"
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
