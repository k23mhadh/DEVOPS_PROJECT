output "gke_cluster_name" {
  description = "GKE Cluster Name"
  value       = module.gke_cluster.kubernetes_cluster_name
}

output "gke_cluster_host" {
  description = "GKE Cluster Host"
  value       = module.gke_cluster.kubernetes_cluster_host
}

output "kubectl_command" {
  description = "kubectl command to connect to the cluster"
  value       = "gcloud container clusters get-credentials ${module.gke_cluster.kubernetes_cluster_name} --zone ${var.zone} --project ${var.project_id}"
}

output "result_service_ip" {
  description = "External IP of the Result service"
  value       = module.k8s_app.result_service_ip
}

output "vote_service_ip" {
  description = "External IP of the Vote service (GCP Load Balancer)"
  value       = module.k8s_app.vote_service_ip
}