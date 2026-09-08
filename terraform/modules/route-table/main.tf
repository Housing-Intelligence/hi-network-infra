resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
    tags = {
    Name        = "${var.name}-public-route-table"
    Environment = var.environment
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.name}-private-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.public_subnet_a_id
}

resource "aws_route_table_association" "public_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.public_subnet_b_id
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.private_subnet_a_id
}

resource "aws_route_table_association" "private_b" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.private_subnet_b_id
}