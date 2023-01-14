resource "aws_eip" "eks_vpc_iep" {
    vpc                                                     = true
    tags = {
        Name                                                = format("%s-vpc-eip", var.cluster_name)
    }
}

resource "aws_nat_gateway" "eks_nat_gw" {
    allocation_id                                           = aws_eip.eks_vpc_iep.id
    subnet_id                                               = aws_subnet.eks_public_subnet_1a.id

    tags = {
        Name                                                = format("%s-nat-gateway", var.cluster_name)
    }  
}

resource "aws_route_table" "eks_nat_route_table" {
    vpc_id                                                  = aws_vpc.cluster_vpc.id

    tags = {
        Name                                                = format("%s-nat-private-rt", var.cluster_name)
    }
}

resource "aws_route" "eks_nat_access" {
    route_table_id                                          = aws_route_table.eks_nat_route_table.id
    destination_cidr_block                                  = "0.0.0.0/0"
    nat_gateway_id                                          = aws_nat_gateway.eks_nat_gw.id
}