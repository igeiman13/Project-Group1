# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group1"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  default     = "Group1-Project"
  type        = string
  description = "Name Prefix"
}

# Provision Public Subnets in VPC
variable "public_subnet_cidrs" {
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs for Dev"
}

# Provision Private Subnets in VPC
variable "private_subnet_cidrs" {
  default     = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs for Dev"
}

# Dev VPC CIDR Range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "VPC for DEV"
}

# Variable to signal the current environment 
variable "env" {
  default     = "Dev"
  type        = string
  description = "Dev Environment"
}
