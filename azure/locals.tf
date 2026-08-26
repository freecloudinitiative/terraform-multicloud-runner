locals {
  all_runners = {
    "runner-1" = {
      location = "westeurope"
      size     = var.instance_size
    }
    "runner-2" = {
      location = "northeurope"
      size     = var.instance_size
    }
    "runner-3" = {
      location = "swedencentral"
      size     = var.instance_size
    }
  }

  runners = var.cluster_mode == "HA" ? local.all_runners : {
    "runner-1" = local.all_runners["runner-1"]
    "runner-2" = local.all_runners["runner-2"]
  }

  ssh_public_key = var.ssh_public_key != "" ? var.ssh_public_key : (length(tls_private_key.ssh) > 0 ? tls_private_key.ssh[0].public_key_openssh : "")
}
