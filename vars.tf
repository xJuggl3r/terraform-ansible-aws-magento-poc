# variables
variable "app" { type = string }
variable "region" { type = string }
variable "vpc_cidr_block" { type = string }
variable "subnet_cidr_block1" { type = string }
variable "subnet_cidr_block10" { type = string }
variable "ssh_cidr_blocks" {
  type        = list(any)
  description = "allowed SSH connection"
  default     = ["0.0.0.0/0"]
}

variable "key_pair_location" {
  default = "~/.ssh/automation.pem"
}

variable "site_name" { type = string }

variable "ami" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }

variable "cert_value" { type = string }
variable "cert_key" { type = string }
variable "www_cert_value" { type = string }
variable "www_cert_key" { type = string }