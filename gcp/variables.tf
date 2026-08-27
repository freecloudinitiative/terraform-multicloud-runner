variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID"
}

variable "region" {
  type        = string
  description = "The default GCP region to deploy resources into"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The default GCP zone to deploy resources into"
  default     = "us-central1-a"
}

variable "instance_name" {
  type        = string
  description = "Prefix for the runner instances"
  default     = "github-runner-gcp"
}

variable "machine_type" {
  type        = string
  description = "The GCP machine type (ARM64: t2a-standard-2)"
  default     = "t2a-standard-2"
}

variable "cluster_mode" {
  type        = string
  description = "Cluster mode: 'simple' (1 VM) or 'HA' (4 VMs)"
  default     = "simple"

  validation {
    condition     = contains(["simple", "HA"], var.cluster_mode)
    error_message = "cluster_mode must be either 'simple' or 'HA'."
  }
}

variable "admin_ip_ranges" {
  type        = list(string)
  description = "IP ranges allowed to SSH to the runners"
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

variable "runners_per_vm" {
  type        = number
  description = "Number of GitHub Actions runner instances to run concurrently per VM"
  default     = 2

  validation {
    condition     = var.runners_per_vm > 0 && floor(var.runners_per_vm) == var.runners_per_vm
    error_message = "runners_per_vm must be a positive integer."
  }
}
