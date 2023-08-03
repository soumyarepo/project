provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    key_name = "dev"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.ubs-public-subnet-1.id
    for_each = toset(["Jenkins-master", "build-slave", "ansible"])
    tags = {
      Name = "${each.key}"
    }
}

resource "aws_security_group" "demo-sg" {
  name_prefix = "demo-sg"
  description = "Example security group for SSH and HTTP"
  vpc_id = aws_vpc.ubs-vpc.id
  

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

  ingress {
    description = "JENKINSPORT"
    from_port   = 8080
    to_port     = 8080
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

resource "aws_vpc" "ubs-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "ubs-vpc"
  }

}

resource "aws_subnet" "ubs-public-subnet-1" {
  vpc_id = aws_vpc.ubs-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "ubs-public-subnet-1"
  }
}

resource "aws_subnet" "ubs-public-subnet-2" {
  vpc_id = aws_vpc.ubs-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "ubs-public-subnet-2"
  }
}

resource "aws_internet_gateway" "ubs-igt" {
  vpc_id = aws_vpc.ubs-vpc.id
  tags = {
    Name = "ubs-igt"
  }
}

resource "aws_route_table" "ubs-public-igt" {
  vpc_id = aws_vpc.ubs-vpc.id
  tags = {
    Name = "ubs-public-igt"
  }
}

resource "aws_route" "ubs-route" {
  route_table_id         = aws_route_table.ubs-public-igt.id
  destination_cidr_block = "0.0.0.0/0"  # Route all traffic (Internet)
  gateway_id             = aws_internet_gateway.ubs-igt.id
}

resource "aws_route_table_association" "ubs-rta-public-1" {
  subnet_id = aws_subnet.ubs-public-subnet-1.id
  route_table_id = aws_route_table.ubs-public-igt.id
}

resource "aws_route_table_association" "ubs-rta-public-2" {
  subnet_id = aws_subnet.ubs-public-subnet-2.id
  route_table_id = aws_route_table.ubs-public-igt.id
}