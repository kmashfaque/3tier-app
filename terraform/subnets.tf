resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = local.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.resource_tag}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = local.availability_zone_1

  tags = {
    Name = "${local.resource_tag}-private-subnet"
  }
}

resource "aws_subnet" "db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidr
  availability_zone = local.availability_zone_1

  tags = {
    Name = "${local.resource_tag}-db-subnet-1"
  }
}

resource "aws_subnet" "db2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidr_2
  availability_zone = local.availability_zone_2

  tags = {
    Name = "${local.resource_tag}-db-subnet-2"
  }
}
