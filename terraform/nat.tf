resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${local.resource_tag}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.resource_tag}-nat-gateway"
  }
}
