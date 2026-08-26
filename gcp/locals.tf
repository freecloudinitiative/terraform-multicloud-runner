locals {
  all_runners = {
    "1" = {
      machine_type = var.machine_type
      zone         = "us-central1-a"
    }
    "2" = {
      machine_type = var.machine_type
      zone         = "us-central1-b"
    }
    "3" = {
      machine_type = var.machine_type
      zone         = "us-central1-f"
    }
  }

  runners = var.cluster_mode == "HA" ? local.all_runners : {
    "1" = local.all_runners["1"]
  }

  admin_ip_ranges = var.admin_ip_ranges
}
