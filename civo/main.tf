data "civo_network" "custom" {
  count = var.network_id == "" ? 0 : 1
  id    = var.network_id
}


data "civo_disk_image" "ubuntu" {
  filter {
    key    = "name"
    values = ["ubuntu-jammy"] # Ubuntu 22.04
  }
}

resource "civo_firewall" "runner_fw" {
  name                 = "${var.instance_name}-fw"
  network_id           = var.network_id == "" ? null : data.civo_network.custom[0].id
  create_default_rules = false

  ingress_rule {
    label      = "ssh"
    action     = "allow"
    protocol   = "tcp"
    port_range = "22"
    cidr       = var.admin_cidrs
  }

  egress_rule {
    label      = "all-tcp"
    action     = "allow"
    protocol   = "tcp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
  }

  egress_rule {
    label      = "all-udp"
    action     = "allow"
    protocol   = "udp"
    port_range = "1-65535"
    cidr       = ["0.0.0.0/0"]
  }
}

resource "civo_instance" "runner" {
  count       = var.cluster_mode == "HA" ? var.ha_node_count : var.simple_node_count
  hostname    = "${var.instance_name}-${count.index + 1}"
  size        = var.instance_size
  disk_image  = data.civo_disk_image.ubuntu.diskimages[0].id
  volume_type = "standard"
  network_id  = var.network_id == "" ? null : data.civo_network.custom[0].id
  firewall_id = civo_firewall.runner_fw.id

  script = templatefile("${path.module}/install_runner.sh.tftpl", {
    github_pat     = var.github_pat
    github_org     = var.github_org
    runners_per_vm = var.runners_per_vm
  })

  lifecycle {
    ignore_changes = [script]
  }
}
