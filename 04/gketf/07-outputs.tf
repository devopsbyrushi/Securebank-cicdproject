output "cluster_name" {
  value = google_container_cluster.securebank_gke.name
}

output "cluster_endpoint" {
  value = google_container_cluster.securebank_gke.endpoint
}

output "node_pool_name" {
  value = google_container_node_pool.gke_nodes.name
}