terraform {
  required_providers {
    digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
    token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "cloud2solutions" {
    name = var.cloud2solutions_name
    region = var.region
    version = "1.24.1-do.0"

    node_pool {
      name          = "default"
      size          = "s-2vcpu-2gb" 
      node_count    = 2
    }
}

variable "cloud2solutions_name" {}
variable "cloud2solutions_token" {}
variable "cloud2solutions_region" {}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_iniciativa.kube_config.0.raw_config
    filename = "kube_config.yaml"
}