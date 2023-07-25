# Access key
variable "access_key" {
  default = "<access-key>"
}
# Secret Key
variable "secret_key" {
  default = "<secret-key>"
}
# Region
variable "region" {
  type        = string
  default     = "us-east-1"
}
# Frontend IP Range
variable "frontend_vpc_range" {
    default = "10.10.0.0/16"  
}

# Backend IP Range
variable "backend_vpc_range" {
    default = "10.11.0.0/16"  
}

# Database IP Range
variable "database_vpc_range" {
    default = "10.12.0.0/16"  
}

# Frontend Subnet IP Range
variable "frontend_subnet_range" {
    default = "10.10.1.0/24"
  
}
# Backend Subnet IP Range
variable "backend_subnet_range" {
    default = "10.11.2.0/24"
  
}

# Database Subnet IP Range
variable "database_subnet_range" {
    default = "10.12.3.0/24"
  
}

# Frontend Subnet zone 
variable "frontend_subnet_zone" {
    default =  "us-east-1a"  
}

# Backend Subnet zone 
variable "backend_subnet_zone" {
    default =  "us-east-1b"  
}

# Database Subnet zone
variable "database_subnet_zone" {
    default =  "us-east-1c"  
}

# Instance Type
variable "instance_type" {
    default = "t2.micro"
}
# Os Flavour 
variable "os_name" {
    default = "ami-0f9ce67dcf718d332"
}

# Key Pair
variable "key" {
    default = "key"
}
# Key pair
variable "private_key_path" {
  description = "Path to the private key file used to connect to EC2 instances."
  type        = string
  default     = "/home/vagrant/kpmg/key.pem"
}

# DB user
variable "db_user" {
    default = "admin"
}

# DB password
variable "db_password" {
    default = "admin123456"
}
