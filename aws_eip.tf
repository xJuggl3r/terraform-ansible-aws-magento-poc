resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.example.id
  depends_on = [
    aws_internet_gateway.gw
  ]
}

resource "aws_eip" "example" {
  vpc = true
}


