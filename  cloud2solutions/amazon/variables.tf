variable "cluster_name" {
  default = "eks-lincros-demo"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "kubernetes_version" {
  default = "1.23"
}

variable "nodes_instances_sizes" {
  default = [
    "t3.large"
  ]
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: `ON_DEMAND`, `SPOT`"
  type        = string
  default     = "SPOT"
}

variable "auto_scale_options" {
  default = {
    min     = 1
    max     = 1
    desired = 1
  }

}