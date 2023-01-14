data "aws_iam_policy_document" "eks_nodes_role" {
  
    version = "2012-10-17"

    statement {

        actions = [ "sts:AssumeRole" ]

        principals {
            type = "Service"
            identifiers = [
                "ec2.amazonaws.com"
            ]
        }

    }
}

resource "aws_iam_role" "eks_nodes_roles" {
  name = format("%s-nodes-role", var.cluster_name)
  assume_role_policy = data.aws_iam_policy_document.eks_nodes_role.json 
  tags = {
    Name                                              = format("%s-nodes-role", var.cluster_name)
  }
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn                                          = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role                                                = aws_iam_role.eks_nodes_roles.name
}

resource "aws_iam_role_policy_attachment" "eks_workernode_policy" {
  policy_arn                                          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role                                                = aws_iam_role.eks_nodes_roles.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_container" {
  policy_arn                                          = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role                                                = aws_iam_role.eks_nodes_roles.name
}