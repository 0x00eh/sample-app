
##########################
# Internet Gateway + Routes
##########################
resource "aws_internet_gateway" "flask_igw" {
  vpc_id = aws_vpc.flask_vpc.id
  tags = { Name = "flask-igw" }
}

resource "aws_route_table" "flask_public_rt" {
  vpc_id = aws_vpc.flask_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.flask_igw.id
  }

  tags = { Name = "flask-public-rt" }
}

resource "aws_route_table_association" "subnet_a_assoc" {
  subnet_id      = aws_subnet.flask_subnet_a.id
  route_table_id = aws_route_table.flask_public_rt.id
}

resource "aws_route_table_association" "subnet_b_assoc" {
  subnet_id      = aws_subnet.flask_subnet_b.id
  route_table_id = aws_route_table.flask_public_rt.id
}