resource "aws_vpc" "main" {
    cidr_block  = var.vpc_cidr
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = local.name
        }
     )

}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            name = local.name
        }
    )
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]
    tags = merge(
        var.common_tags,
        var.public_subnets_tags,
        {
          name = "${local.name}-public-${local.az_names[count.index]}"  
        }
    )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]
    tags = merge(
        var.common_tags,
        var.private_subnets_tags,
        {
          name = "${local.name}-private-${local.az_names[count.index]}"  
        }
    )
}

resource "aws_subnet" "database" {
    count = length(var.database_subnets_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnets_cidr[count.index]
    availability_zone = local.az_names[count.index]
    tags = merge(
        var.common_tags,
        var.database_subnets_tags,
        {
          name = "${local.name}-database-${local.az_names[count.index]}"  
        }
    )
}

resource "aws_db_subnet_group" "default" {
    name = "${local.name}"
    subnet_ids = aws_subnet.databse[*].id

        tags = {
            name = "my db subnet group"
        } 
    
}
 resource "aws_eip" "eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.public[0].indent

    tags = merge(
        var.common_tags,
        var.nat_gateway_tags,
        {
            name = "${local.name}"
        }
    )

    depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.public_route_table_tags,
        {
            name = "${local.name}-public"
        }

    )
}
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.private_route_table_tags,
        {
            name = "${local.name}-private"
        }

    )
}
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.database_route_table_tags,
        {
            name = "${local.name}-databse"
        }

    )
}

resource "aws_route" "public_route" {
    route_table_id   = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route" {
    route_table_id   = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database_route" {
    route_table_id   = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets_cidr)
    subnet_id = element(aws_subnet.public[*].id, count.index)
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets_cidr)
    subnet_id = element(aws_subnet.private[*].id, count.index)
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    count = length(var.database_subnets_cidr)
    subnet_id = element(aws_subnet.database[*].id, count.index)
    route_table_id = aws_route_table.database.id
}