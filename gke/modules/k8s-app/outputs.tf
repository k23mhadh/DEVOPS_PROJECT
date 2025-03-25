output "result_service_ip" {
  description = "External IP of the Result service"
  value       = kubernetes_service.result.status.0.load_balancer.0.ingress.0.ip
}

output "vote_service_ip" {
  description = "External IP of the Vote service"
  value       = kubernetes_service.vote.status.0.load_balancer.0.ingress.0.ip
}