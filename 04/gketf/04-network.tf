data "google_compute_network" "existing_vpc" {
  name = "securebank-vpc"
}

data "google_compute_subnetwork" "existing_subnet" {
  name   = "securebank-subnet"
  region = var.region
}