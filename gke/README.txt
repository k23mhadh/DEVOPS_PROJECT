GKE Cluster Module: Creates a Google Kubernetes Engine cluster with a node pool.
Kubernetes App Module: Deploys all application components as Kubernetes resources.

Steps : 
1 GCP Authentication : gcloud auth application-default login

2 commands :
    cd gke
    export TF_VAR_project_id=your-gcp-project-id
    terraform init
    terraform apply