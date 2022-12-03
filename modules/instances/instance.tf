variable "ENV" {
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "PUBLIC_SUBNETS" {
  type = list
}

variable "VPC_ID" {
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "sshkey-${var.ENV}.pub"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.INSTANCE_TYPE

  subnet_id = element(var.PUBLIC_SUBNETS, 0)
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name = aws_key_pair.sshkeypair.key_name

  tags = {
    Name         = "instance-${var.ENV}"
    Environmnent = var.ENV
  }
}

resource "aws_security_group" "allow-ssh" {
  vpc_id      = var.VPC_ID
  name        = "allow-ssh-${var.ENV}"
  description = "allow ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENV
  }
}

resource "aws_key_pair" "sshkeypair" {
  key_name   = "sshkeypair-${var.ENV}"
  public_key = file("${path.root}/${var.PATH_TO_PUBLIC_KEY}")
}