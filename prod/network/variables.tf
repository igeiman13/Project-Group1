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
  default     = ["10.250.1.0/24", "10.250.2.0/24", "10.250.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs for Prod"
}

# Provision Private Subnets in VPC
variable "private_subnet_cidrs" {
  default     = ["10.250.4.0/24", "10.250.5.0/24", "10.250.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs for prod"
}

# prod VPC CIDR Range
variable "vpc_cidr" {
  default     = "10.250.0.0/16"
  type        = string
  description = "VPC for prod"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "prod Environment"
}
