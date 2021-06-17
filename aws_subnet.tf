# Create a subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block1
  availability_zone = "${var.region}a"
  tags              = { Name = "${var.app}-public-subnet" }
}
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block10
  availability_zone = "${var.region}a"
  tags              = { Name = "${var.app}-private1-subnet" }
}
