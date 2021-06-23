# Provides a resource to create a VPC routing table.
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "${var.app}-public-route" }
}

# Provides a resource to create an association between a route table and a subnet or a route table and an internet gateway.
resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}
