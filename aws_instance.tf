# Provides an EC2 instance resource.
resource "aws_instance" "web" {
  # ami                         = "ami-0747bdcabd34c712a" #Ubuntu 18 us-east-1
  ami                         = "ami-032930428bf1abbff" #Amazon Linux us-east-1
  instance_type               = "t3a.medium"            # Minimum shape for a Magento instance
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = "automation"
  tags                        = { Name = var.app }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.key_pair_location)
  }

  # Gets Instance IP and save it in a file so all.yml can be edited later
  provisioner "remote-exec" {
    inline = [
      "echo ${self.public_ip} >> /tmp/public_ip.txt",
      "echo ${var.site_name} >> /tmp/sitename.txt",
      "sudo mkdir /tmp/ansible-magento2",
      "sudo chown -R ec2-user:ec2-user /tmp/ansible-magento2"
    ]
  }

  # Copies ansible-magento2/ dir to /tmp/ansible-magento2
  provisioner "file" {
    source      = "./ansible-magento2"
    destination = "/tmp"
  }

  #Copies ansible-magento script
  provisioner "file" {
    source      = "ansible_magento.sh"
    destination = "/tmp/ansible_magento.sh"
  }

  #Runs ansible-magento script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ansible_magento.sh",
      "sudo /tmp/ansible_magento.sh"
    ]
  }

}
