
# Volume
resource "docker_volume" "postgres_data" {
  name = "postgres-data"
}

# Redis
resource "docker_image" "redis" {
  name = "redis:alpine"
}

resource "docker_container" "redis" {
  name  = "redis"
  image = docker_image.redis.name
  
  networks_advanced {
    name = "my_network"
  }
}

# Database
resource "docker_image" "db" {
  name = "postgres:15-alpine"
}

resource "docker_container" "db" {
  name  = "db"
  image = docker_image.db.name
  
  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
    "POSTGRES_DB=${var.postgres_db}"
  ]
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  networks_advanced {
    name = "my_network"
  }
}

# Vote
resource "docker_image" "vote" {
  name = "${var.image_registry}/vote"
  build {
    context    = "../vote"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "vote" {
  name  = "vote"
  image = docker_image.vote.name
  
  env = [
    "OPTION_A=${var.option_a}",
    "OPTION_B=${var.option_b}"
  ]
  
  networks_advanced {
    name = "my_network"
  }
  
  depends_on = [docker_container.redis, docker_container.db]
}

# Worker
resource "docker_image" "worker" {
  name = "${var.image_registry}/worker"
  build {
    context    = "../worker"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "worker" {
  name  = "worker"
  image = docker_image.worker.name
  
  networks_advanced {
    name = "my_network"
  }
  
  depends_on = [docker_container.redis, docker_container.db]
}

# Result
resource "docker_image" "result" {
  name = "${var.image_registry}/result"
  build {
    context    = "../result"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "result" {
  name  = "result"
  image = docker_image.result.name
  
  ports {
    internal = 4000
    external = 4000
  }
  
  networks_advanced {
    name = "my_network"
  }
  
  depends_on = [docker_container.db]
}

# Nginx
resource "docker_image" "nginx" {
  name = "${var.image_registry}/nginx-lb"
  build {
    context    = "../nginx"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.name
  
  ports {
    internal = 80
    external = 80
  }
  
  networks_advanced {
    name = "my_network"
  }
  
  depends_on = [docker_container.vote]
}

# Seed
resource "docker_image" "seed" {
  name = "${var.image_registry}/seed"
  build {
    context    = "../seed-data"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "seed" {
  name  = "seed"
  image = docker_image.seed.name
  
  networks_advanced {
    name = "my_network"
  }
  
  depends_on = [docker_container.nginx]
}
