module "network" {
  source                                          = "./modules/network"

  cluster_name                                    = var.cluster_name
  aws_region                                      = var.aws_region
}

module "master" {
  source                                          = "./modules/master"

  cluster_name                                    = var.cluster_name
  aws_region                                      = var.aws_region
  kubernetes_version                              = var.kubernetes_version

  cluster_vpc                                     = module.network.cluster_vpc
  eks_private_subnet_1a                           = module.network.eks_private_subnet_1a
  eks_private_subnet_1b                           = module.network.eks_private_subnet_1b
}


module "nodes" {
  source                                          = "./modules/nodes"

  cluster_name                                    = var.cluster_name
  aws_region                                      = var.aws_region
  kubernetes_version                              = var.kubernetes_version

  cluster_vpc                                     = module.network.cluster_vpc
  eks_private_subnet_1a                           = module.network.eks_private_subnet_1a
  eks_private_subnet_1b                           = module.network.eks_private_subnet_1b
  eks_public_subnet_1a                            = module.network.eks_public_subnet_1a
  eks_public_subnet_1b                            = module.network.eks_public_subnet_1b

  eks_cluster                                     = module.master.eks_cluster
  eks_cluster_master_sg                           = module.master.security_group

  nodes_instances_sizes                           = var.nodes_instances_sizes
  capacity_type                                   = var.capacity_type 
  auto_scale_options                              = var.auto_scale_options
  #auto_scale_cpu                                 = var.auto_scale_cpu
}