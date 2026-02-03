



provider "aws" {
region = "eu-west-1"  
}







resource "aws_vpc" "my_vpc" {
cidr_block           = "10.0.0.0/16"
enable_dns_support   = true
enable_dns_hostnames = true

tags = {
Name = "my_custom_vpc"
}
}





resource "aws_subnet" "public_subnet" {
vpc_id                  = aws_vpc.my_vpc.id
cidr_block              = "10.0.1.0/24"
map_public_ip_on_launch = true

tags = {
Name = "my_public_subnet"
}
}



resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.my_vpc.id

tags = {
Name = "my_igw"
}
}



resource "aws_route_table" "public_rt" {
vpc_id = aws_vpc.my_vpc.id

route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}

tags = {
Name = "public_route_table"
}
}

resource "aws_route_table_association" "public_assoc" {
subnet_id      = aws_subnet.public_subnet.id
route_table_id = aws_route_table.public_rt.id
}



resource "aws_security_group" "web_sg" {
name        = "web_sg"
description = "Allow SSH and HTTP"
vpc_id      = aws_vpc.my_vpc.id

ingress {
from_port   = 22
to_port     = 22
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "web_sg"
}
}



resource "aws_instance" "web" {
ami           = "ami-0c94855ba95c71c99"  # Ubuntu 22.04 in us-east-1, change if needed
instance_type = "t3.micro"
subnet_id     = aws_subnet.public_subnet.id
security_groups = [aws_security_group.web_sg.name]
key_name      = "my-keypair"  # Replace with your actual AWS keypair name

tags = {
Name = "MyWebServer"
}
}
