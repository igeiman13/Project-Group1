# ASG Instance Type
variable "type" {
  default     = "t3.micro"
  type        = string
  description = "Dev Instances Type"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Dev Environment"
}

# Number of Instances in AutoScalingGroup
variable "instance_count" {
  default     = "2"
  type        = string
  description = "Dev Instances Count"
}
