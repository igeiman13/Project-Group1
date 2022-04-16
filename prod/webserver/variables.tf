# ASG Instance Type
variable "type" {
  default     = "t3.medium"
  type        = string
  description = "prod Instances Type"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "prod Environment"
}

# Number of Instances in AutoScalingGroup
variable "instance_count" {
  default     = "2"
  type        = string
  description = "prod Instances Count"
}
