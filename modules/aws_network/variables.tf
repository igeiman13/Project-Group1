# Default Tags
variable "default_tags" {
  default = {
    "Owner" = "Group1"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

# Name Prefix
variable "prefix" {
  default     = "Group1-Project"
  type        = string
  description = "Name Prefix"
}

# Variable to Signal Current Environment
variable "env" {
  default     = "dev"
  type        = string
  description = "Dev-Environment"
}

# VPC CIDR Range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "DEV VPC"
}

# Provision Public Subnets in VPC
variable "public_subnet_cidrs" {
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision Private Subnets in VPC
variable "private_subnet_cidrs" {
  default     = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# Number of Instances in AutoScalingGroup
variable "instance_count" {
  default     = "2"
  type        = string
  description = "Dev Instances Count"
}

# ASG Instance Type
variable "type" {
  default     = "t3.micro"
  type        = string
  description = "Dev Instances Type"
}
