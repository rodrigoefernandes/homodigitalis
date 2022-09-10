resource "aws_internet_gateway" "prod-igw" {
    vpc_id = "${aws_vpc.prod-vpc.id}"

    tags = {
      Name = "prod-igw"
    }
}

//public subnet route table and association with IGW

resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    route {
        
        cidr_block = "0.0.0.0/0"         
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
    }
    
  tags = {
    Name = "web-crt"
    }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.web_subnet.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}

//NAT GATEWAY and EIP

resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id = aws_subnet.web_subnet.id

  tags = {
    "Name" = "nat_gateway"
  }
}


//WORKLOAD ROUTE TABLE ASSOCIATED WITH NAT GW

resource "aws_route_table" "workload_route_table" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat_gateway.id
     }

  tags = {
    Name = "workload-crt"
    }
}

resource "aws_route_table_association" "workload_rt_assoc" {
  subnet_id = aws_subnet.workload_subnet.id
  route_table_id = aws_route_table.workload_route_table.id
}

//DB ROUTE TABLE ASSOCIATED WITH NAT GW

resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
     }

    tags = {
      Name = "db-crt"
    }
  
}

resource "aws_route_table_association" "db_rt_assoc" {
  subnet_id = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.db_route_table.id
}


// PUBLIC WEB SECURITY GROUP

resource "aws_security_group" "web-sg" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 8
        to_port = 0
        protocol = "icmp"     
    }

tags = {
    Name = "web-sg"
}

     
}

/// WORKLOAD SECURITY GROUP

resource "aws_security_group" "workload-sg" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"        
        security_groups = ["${aws_security_group.web-sg.id}"]
    }
 
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.web-sg.id}"]
    }

    tags = {
    Name = "workload-sg"
}

}

// DB SECURITY GROUP

resource "aws_security_group" "db-sg" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"   
        security_groups = ["${aws_security_group.workload-sg.id}"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.workload-sg.id}"]

    }
    
    tags = {
    Name = "db-sg"
}

}


