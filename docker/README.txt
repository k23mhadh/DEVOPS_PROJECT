# Note: Before applying this Terraform configuration, 
# you must create the external network manually with:
# docker network create my_network


To apply the Docker deployment:
cd docker
terraform init
terraform apply


After applying, you can access:

The voting interface at: http://localhost:80
The results dashboard at: http://localhost:4000