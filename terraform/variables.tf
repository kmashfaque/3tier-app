variable "aws_region" {
  description = "AWS region to deploy the infrastructure in."
  type        = string
  default     = "us-east-1"
}

variable "admin_cidr" {
  description = "CIDR block allowed to access SSH for bastion and web servers."
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_pair_name" {
  description = "AWS key pair name used for EC2 SSH access."
  type        = string
  default     = "3tier-key"
}

variable "public_key_path" {
  description = "Path to the public SSH key used to create the AWS key pair."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private application subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR block for the first private database subnet."
  type        = string
  default     = "10.0.3.0/24"
}

variable "db_subnet_cidr_2" {
  description = "CIDR block for the second private database subnet."
  type        = string
  default     = "10.0.4.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for bastion, web, and app servers."
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS instance class for the MySQL database."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage size for the RDS instance in GB."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Database name created on RDS."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database administrative username for RDS."
  type        = string
  default     = "appuser"
}

variable "db_password" {
  description = "Database password for the RDS user. Set a secure value before deployment."
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}
