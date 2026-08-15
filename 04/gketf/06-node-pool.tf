resource "google_container_node_pool" "gke_nodes" {

  name       = var.node_pool_name
  cluster    = google_container_cluster.securebank_gke.name
  location   = var.zone
  node_count = var.node_count

  node_config {

    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      environment = "securebank"
    }

    tags = [
      "gke-node"
    ]
  }
}