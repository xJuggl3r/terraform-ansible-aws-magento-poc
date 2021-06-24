# Provides an EC2 instance resource.
resource "aws_instance" "web" {
  # ami                         = "ami-0747bdcabd34c712a" #Ubuntu 18 us-east-1
  ami                         = var.ami           #Amazon Linux us-east-1
  instance_type               = var.instance_type # Minimum shape for a Magento instance
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.instance.id]
  key_name                    = var.key_name
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

  # #Copies certs 
  # provisioner "file" {
  #   source      = "./certs/localhost.crt"
  #   destination = "/tmp/localhost.crt"
  # }

  # #Copies cert_key 
  # provisioner "file" {
  #   source      = "./certs/localhost.key"
  #   destination = "/tmp/localhost.key"
  # }

  # #Copies cert_bundle 
  # provisioner "file" {
  #   source      = "./certs/ca-bundle.crt"
  #   destination = "/tmp/ca-bundle.crt"
  # }

  # #Copies cert_bundle-client 
  # provisioner "file" {
  #   source      = "./certs/ca-bundle-client.crt"
  #   destination = "/tmp/ca-bundle-client.crt"
  # }

  # #Copies cert_bundle_anr 
  # provisioner "file" {
  #   source      = "./certs/anr4x4_com_br.crt"
  #   destination = "/tmp/anr4x4_com_br.crt"
  # }


  #Runs ansible-magento script
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/ansible_magento.sh",
      "sudo /tmp/ansible_magento.sh"
    ]
  }

}
