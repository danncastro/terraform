output "eks_cluster" {
  value = aws_eks_cluster.eks_cluster_master
}

output "security_group" {
  value = aws_security_group.eks_cluster_master_sg
}