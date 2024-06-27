#step 1   create vpc

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Myterraform_VPC"
  }
}

#step 2 create public subnet

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

#step 3   create private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  tags = {
    Name = "my_private"
  }
}

#step 4   create IG 

resource "aws_internet_gateway" "my_IG" {
  vpc_id = aws_vpc.my_vpc.id
}


#step 5   create route table for public subnet

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IG.id
  }
}

#step 6   associate rt with public subnet

resource "aws_route_table_association" "publicRTassociation" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_RT.id
}
