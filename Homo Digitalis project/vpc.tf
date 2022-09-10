resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"

    tags = {
      Name = "prod-vpc"
    }
}

resource "aws_subnet" "web_subnet" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
    "Name" = "web_subnet"
  }
  
}

resource "aws_subnet" "workload_subnet" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
    "Name" = "workload_subnet"
  }
  
}

resource "aws_subnet" "db_subnet" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1a"
    tags = {
    "Name" = "db_subnet"
  }
  
}








