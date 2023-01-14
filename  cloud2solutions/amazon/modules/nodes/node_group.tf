resource "aws_eks_node_group" "eks_ng_private_ondemand" {
  
    cluster_name                                        = var.eks_cluster.name
    node_group_name                                     = format("%s-node-group-private-ondemand", var.cluster_name)
    node_role_arn                                       = aws_iam_role.eks_nodes_roles.arn

    subnet_ids = [
        var.eks_private_subnet_1a.id,
        var.eks_private_subnet_1b.id
    ]

    instance_types                                      = var.nodes_instances_sizes

    scaling_config {
        desired_size                                    = lookup(var.auto_scale_options, "desired")
        max_size                                        = lookup(var.auto_scale_options, "max")
        min_size                                        = lookup(var.auto_scale_options, "min")
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
        Name                                            = format("%s-instances-private",var.cluster_name)
    }
}

resource "aws_eks_node_group" "eks_ng_public_ondemand" {
  
    cluster_name                                        = var.eks_cluster.name
    node_group_name                                     = format("%s-node-group-public-ondemand", var.cluster_name)
    node_role_arn                                       = aws_iam_role.eks_nodes_roles.arn

    subnet_ids = [
        var.eks_public_subnet_1a.id,
        var.eks_public_subnet_1b.id
    ]

    instance_types                                      = var.nodes_instances_sizes

    scaling_config {
        desired_size                                    = lookup(var.auto_scale_options, "desired")
        max_size                                        = lookup(var.auto_scale_options, "max")
        min_size                                        = lookup(var.auto_scale_options, "min")
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
        Name                                            = format("%s-instances-public",var.cluster_name)
    }
}

resource "aws_eks_node_group" "eks_ng_private_spot" {
  
    cluster_name                                        = var.eks_cluster.name
    node_group_name                                     = format("%s-node-group-private-spot", var.cluster_name)
    node_role_arn                                       = aws_iam_role.eks_nodes_roles.arn

    subnet_ids = [
        var.eks_private_subnet_1a.id,
        var.eks_private_subnet_1b.id
    ]

    instance_types                                      = var.nodes_instances_sizes
    capacity_type                                       = var.capacity_type

    scaling_config {
        desired_size                                    = lookup(var.auto_scale_options, "desired")
        max_size                                        = lookup(var.auto_scale_options, "max")
        min_size                                        = lookup(var.auto_scale_options, "min")
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
        Name                                            = format("%s-instances-spot-private",var.cluster_name)
    }
}

resource "aws_eks_node_group" "eks_node_group_public_spot" {
  
    cluster_name                                        = var.eks_cluster.name
    node_group_name                                     = format("%s-node-group-public-spot", var.cluster_name)
    node_role_arn                                       = aws_iam_role.eks_nodes_roles.arn

    subnet_ids = [
        var.eks_public_subnet_1a.id,
        var.eks_public_subnet_1b.id
    ]

    instance_types                                      = var.nodes_instances_sizes
    capacity_type                                       = var.capacity_type

    scaling_config {
        desired_size                                    = lookup(var.auto_scale_options, "desired")
        max_size                                        = lookup(var.auto_scale_options, "max")
        min_size                                        = lookup(var.auto_scale_options, "min")
    }

    tags = {
        "kubernetes.io/cluster/${var.cluster_name}"     = "owned"
        Name                                            = format("%s-instances-spot-public",var.cluster_name)
    }
}