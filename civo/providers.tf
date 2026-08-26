terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = "~> 1.1.0"
    }
  }
}

provider "civo" {
  region = var.region
  # Note: You should export CIVO_TOKEN in your environment variables.
}
