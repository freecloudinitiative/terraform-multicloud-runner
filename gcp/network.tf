resource "google_compute_network" "runner_vpc" {
  name                    = "runner-vpc"
  auto_create_subnetworks = true
}
