resource "google_compute_instance" "runner" {
  for_each     = local.runners
  name         = "${var.instance_name}-${each.key}"
  machine_type = each.value.machine_type
  zone         = each.value.zone
  tags         = ["github-runner"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts-arm64"
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = google_compute_network.runner_vpc.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = templatefile("${path.module}/install_runner.sh.tftpl", {
    github_pat     = var.github_pat
    github_org     = var.github_org
    runners_per_vm = var.runners_per_vm
  })

  service_account {
    scopes = ["cloud-platform"]
  }
}
