# Author - Shaik Minazul Abeddin
# Note in the variables.tf, you have to define access key and secret key to run this Terraform script

# Declare the required AWS provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
# Configure the AWS provider with access key, secret key, and region from variables
provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# Create a new VPC for the frontend

resource "aws_vpc" "frontend_vpc" {
  cidr_block = var.frontend_vpc_range
  enable_dns_support = "true"
  enable_dns_hostnames = "true"  
  tags = {
    Name = "Frontend VPC"
  }
}

# Create a new VPC for the backend
resource "aws_vpc" "backend_vpc" {
  cidr_block = var.backend_vpc_range
  enable_dns_support = "true"
  enable_dns_hostnames = "true"  
  tags = {
    Name = "Backend VPC"
  }
}

# Create a new VPC for the Database
resource "aws_vpc" "database_vpc" {
  cidr_block = var.database_vpc_range
  enable_dns_support = "true"
  enable_dns_hostnames = "true"  
  tags = {
    Name = "Database VPC"
  }
}

# Create a subnet for the frontend VPC

resource "aws_subnet" "frontend_subnet" {
  vpc_id     = aws_vpc.frontend_vpc.id
  cidr_block = var.frontend_subnet_range
  availability_zone = var.frontend_subnet_zone 
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Frontend Subnet"
  }
}

# Create a subnet for the backend VPC

resource "aws_subnet" "backend_subnet" {
  vpc_id     = aws_vpc.backend_vpc.id
  cidr_block = var.backend_subnet_range
  availability_zone = var.backend_subnet_zone 
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Backend Subnet"
  }
}

# Create a subnet for the database VPC

resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.database_vpc.id
  cidr_block = var.database_subnet_range
  availability_zone = var.database_subnet_zone 
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Database Subnet"
  }
}

# Create an internet gateway for the frontend VPC

resource "aws_internet_gateway" "frontend_igw" {
  vpc_id = aws_vpc.frontend_vpc.id

  tags = {
    Name = "Frontend Internet Gateway"
  }
}

# Create an internet gateway for the backend VPC

resource "aws_internet_gateway" "backend_igw" {
  vpc_id = aws_vpc.backend_vpc.id

  tags = {
    Name = "Backend Internet Gateway"
  }
}

# Create an internet gateway for the database VPC

resource "aws_internet_gateway" "database_igw" {
  vpc_id = aws_vpc.database_vpc.id

  tags = {
    Name = "Database Internet Gateway"
  }
}

# Create a route table for each VPC

resource "aws_route_table" "frontend_route_table" {
  vpc_id = aws_vpc.frontend_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.frontend_igw.id
  }

  tags = {
    Name = "Frontend Route Table"
  }
}

resource "aws_route_table" "backend_route_table" {
  vpc_id = aws_vpc.backend_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.backend_igw.id
  }

  tags = {
    Name = "Backend Route Table"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.database_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.database_igw.id
  }

  tags = {
    Name = "Database Route Table"
  }
}

# Associate the route table with the subnet

resource "aws_route_table_association" "frontend_rt_association" {
  subnet_id      = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.frontend_route_table.id
}

resource "aws_route_table_association" "backend_rt_association" {
  subnet_id      = aws_subnet.backend_subnet.id
  route_table_id = aws_route_table.backend_route_table.id
}

resource "aws_route_table_association" "database_rt_association" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database_route_table.id
}

# Create security groups and rules for frontend, backend, and database

resource "aws_security_group" "frontend_sg" {
  name_prefix = "frontend_sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "backend_sg" {
  name_prefix = "backend_sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

resource "aws_security_group" "db_sg" {
  name_prefix = "db_sg"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

# Define ingress rules for security groups to allow specific traffic

resource "aws_security_group_rule" "frontend_ingress_http_from_backend" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_sg.id
  source_security_group_id = aws_security_group.backend_sg.id
}

resource "aws_security_group_rule" "frontend_ingress_http_any" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.frontend_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend_ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.frontend_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "backend_ingress_http_from_any" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  security_group_id = aws_security_group.backend_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "backend_ingress_http_from_frontend" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  security_group_id = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.frontend_sg.id
}

resource "aws_security_group_rule" "backend_ingress_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.backend_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "backend_ingress_db" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  security_group_id = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}

# Create EC2 instances for frontend and backend
resource "aws_instance" "frontend" {
  ami           = var.os_name 
  instance_type = var.instance_type
  key_name      = var.key  
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]  
  tags = {
    Name = "Frontend Instance"
  }
}

resource "aws_instance" "backend" {
  ami           = var.os_name 
  instance_type = var.instance_type
  key_name      = var.key    
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  tags = {
    Name = "Backend Instance"
  }
}

# Create RDS MySQL instance
resource "aws_db_instance" "database" {
  engine           = "mysql"
  instance_class   = "db.t2.micro"
  allocated_storage = 20
  storage_type     = "gp2"
  username         = var.db_user
  password         = var.db_password
  tags = {
    Name = "Database Instance"
  }
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot = true  # Set skip_final_snapshot to true
}

# Output the public IP addresses of instances and the database endpoint
output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.database.endpoint
}

# Query metadata of all instances and save JSON output in files

resource "null_resource" "metadata_query" {
  depends_on = [
    aws_instance.frontend,
    aws_instance.backend,
    aws_db_instance.database,
  ]

  provisioner "local-exec" {
    command = <<-EOF
      frontend_metadata=$(aws ec2 describe-instances --instance-id ${aws_instance.frontend.id} --query 'Reservations[].Instances[0]' --region ${var.region} --output json)
      echo $frontend_metadata > frontend_metadata.json

      backend_metadata=$(aws ec2 describe-instances --instance-id ${aws_instance.backend.id} --query 'Reservations[].Instances[0]' --region ${var.region} --output json)
      echo $backend_metadata > backend_metadata.json

      database_metadata=$(aws rds describe-db-instances --db-instance-identifier ${aws_db_instance.database.identifier} --region ${var.region} --output json)
      echo $database_metadata > database_metadata.json
    EOF
  }
}