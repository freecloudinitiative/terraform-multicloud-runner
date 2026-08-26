locals {
  all_runners = {
    "1" = {
      location = "northeurope"
      size     = var.instance_size
    }
    "2" = {
      location = "germanywestcentral"
      size     = var.instance_size
    }
    "3" = {
      location = "swedencentral"
      size     = var.instance_size
    }
  }

  runners = var.cluster_mode == "HA" ? local.all_runners : {
    "1" = local.all_runners["1"]
  }

  ssh_public_key = var.ssh_public_key != "" ? var.ssh_public_key : (length(tls_private_key.ssh) > 0 ? tls_private_key.ssh[0].public_key_openssh : "")
}
