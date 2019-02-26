
################ VPC #################
resource "aws_vpc" "pbpv" {
  cidr_block       = "${var.main_vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "public-private VPC"
  }
}

 ################# Subnets #############
resource "aws_subnet" "subpb" {
  vpc_id     = "${aws_vpc.pbpv.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.availability_zone1}"


  tags {
    Name = "public subnet"
    }
}
resource "aws_subnet" "subpv" {
  vpc_id     = "${aws_vpc.pbpv.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.availability_zone2}"


  tags {
    Name = "private subnet"
  }
}

resource "aws_subnet" "subnat" {
  vpc_id     = "${aws_vpc.pbpv.id}"
  cidr_block = "10.0.7.0/24"
  availability_zone = "${var.availability_zone1}"


  tags {
    Name = "public NAT subnet"
  }
}

######## IGW ###############
resource "aws_internet_gateway" "main-igw" {
  vpc_id = "${aws_vpc.pbpv.id}"

  tags {
    Name = "main-igw"
  }
}

########### NAT ##############
resource "aws_eip" "nat" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.subnat.id}"

  tags {
    Name = "main-nat"
  }
}

############# Route Tables ##########

resource "aws_route_table" "main-public-rt" {
  vpc_id = "${aws_vpc.pbpv.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main-igw.id}"
  }

  tags {
    Name = "main-public-rt"
  }
}

resource "aws_route_table" "main-private-rt" {
  vpc_id = "${aws_vpc.pbpv.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.main-natgw.id}"
  }

  tags {
    Name = "main-private-rt"
  }
}

######### PUBLIC Subnet assiosation with rotute table    ######
resource "aws_route_table_association" "public-assoc-1" {
  subnet_id      = "${aws_subnet.subpb.id}"
  route_table_id = "${aws_route_table.main-public-rt.id}"
}

resource "aws_route_table_association" "public-assoc-2" {
  subnet_id      = "${aws_subnet.subnat.id}"
  route_table_id = "${aws_route_table.main-public-rt.id}"
}

########## PRIVATE Subnets assiosation with rotute table ######
resource "aws_route_table_association" "private-assoc-1" {
  subnet_id      = "${aws_subnet.subpv.id}"
  route_table_id = "${aws_route_table.main-private-rt.id}"
}