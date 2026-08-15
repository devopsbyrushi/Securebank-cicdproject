resource "google_container_cluster" "securebank_gke" {

  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = data.google_compute_network.existing_vpc.self_link
  subnetwork = data.google_compute_subnetwork.existing_subnet.self_link

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  deletion_protection = false

  depends_on = [
    google_project_service.container,
    google_project_service.compute
  ]
}