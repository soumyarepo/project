provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0ded8326293d3201b"
    instance_type = "t2.micro"
    key_name = "dev"
}