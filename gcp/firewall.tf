resource "google_compute_firewall" "allow_ssh" {
  name    = "runner-allow-ssh"
  network = google_compute_network.runner_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = local.admin_ip_ranges
  target_tags   = ["github-runner"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "runner-allow-internal"
  network = google_compute_network.runner_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.128.0.0/9"]
}
