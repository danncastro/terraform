terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Product                                             = format("%s-lincros", var.cluster_name)
      Environment                                         = format("%s-dev", var.cluster_name)
      Type                                                = format("%s-kubernetes", var.cluster_name)
      Terraform                                           = "true"
    } 
  }
}

provider "helm" {
  kubernetes {
    region = var.aws_region
  }
}