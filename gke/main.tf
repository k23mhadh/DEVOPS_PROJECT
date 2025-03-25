module "gke_cluster" {
  source = "./modules/gke-cluster"

  project_id   = var.project_id
  region       = var.region
  zone         = var.zone
  cluster_name = var.cluster_name
}

module "k8s_app" {
  source = "./modules/k8s-app"

  option_a          = var.option_a
  option_b          = var.option_b
  postgres_password = var.postgres_password
  image_registry    = var.image_registry

  depends_on = [module.gke_cluster]
}