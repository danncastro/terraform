resource "aws_internet_gateway" "eks_igw" {
    vpc_id                                                  = aws_vpc.cluster_vpc.id

    tags = {
        Name                                                = format("%s-internet-gateway", var.cluster_name)
    }
}

resource "aws_route_table" "eks_igw_route_table" {
    vpc_id                                                  = aws_vpc.cluster_vpc.id

    tags = {
        Name                                                = format("%s-igw-public-rt", var.cluster_name)
    }
}


resource "aws_route" "eks_igw_access" {
    route_table_id                                          = aws_route_table.eks_igw_route_table.id
    destination_cidr_block                                  = "0.0.0.0/0"
    gateway_id                                              = aws_internet_gateway.eks_igw.id
}