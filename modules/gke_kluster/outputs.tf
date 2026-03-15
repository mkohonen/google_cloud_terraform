# modules/gke_cluster/outputs.tf
output "cluster_name" {
  value = google_container_cluster.primary.name
}