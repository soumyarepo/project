provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0ded8326293d3201b"
    instance_type = "t2.micro"
    key_name = "dev"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
}

resource "aws_security_group" "demo-sg" {
  name_prefix = "demo-sg"
  description = "Example security group for SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SSH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}


