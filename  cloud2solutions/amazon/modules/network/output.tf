output "cluster_vpc" {
  value = aws_vpc.cluster_vpc
}

output "eks_private_subnet_1a" {
  value = aws_subnet.eks_private_subnet_1a
}

output "eks_private_subnet_1b" {
  value = aws_subnet.eks_private_subnet_1b
}

output "eks_public_subnet_1a" {
  value = aws_subnet.eks_public_subnet_1a
}

output "eks_public_subnet_1b" {
  value = aws_subnet.eks_public_subnet_1b
}