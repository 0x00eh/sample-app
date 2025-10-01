##########################
# VPC & Networking
##########################
resource "aws_vpc" "flask_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "flask_subnet_a" {
  vpc_id                  = aws_vpc.flask_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "flask_subnet_b" {
  vpc_id                  = aws_vpc.flask_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}