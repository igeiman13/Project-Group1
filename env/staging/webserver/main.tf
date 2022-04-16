# Define Provider
provider "aws" {
  region = "us-east-1"
}

# Data Source for AMI ID
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



# Retrieve Global Variables
module "globalvars"{
  source = "../../../modules/globalvars"
}

# Define Local Tagss
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix = module.globalvars.prefix
  name_prefix  = "${local.prefix}-${var.env}"
}


# Remote State to Retrive Data.
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}1-group1-acsproject"
    key    = "${var.env}-network/terraform.tfstate"
    region = "us-east-1"
  }
}



# Load Balancer Target Group
resource "aws_lb_target_group" "staging_lb" {
  name     = "${local.name_prefix}-Alb-Tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id
}

# Application Load Balancer
resource "aws_lb" "app_load_balancer" {
  name               = "${local.name_prefix}-Alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.staging_lb_sg.id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_id
  enable_deletion_protection = false
}

# Load Balancer Listener Resource
resource "aws_lb_listener" "staging_lb_listener" {
   load_balancer_arn    = aws_lb.app_load_balancer.id
   port                 = "80"
   protocol             = "HTTP"
   default_action {
    target_group_arn = aws_lb_target_group.staging_lb.id
    type             = "forward"
  }
}

# Load Balancer Security Group
resource "aws_security_group" "staging_lb_sg" {
  name        = "${local.name_prefix}-Allow_Http"
  description = "Allow HTTP Inbound Traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "HTTP Inbound Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-LB_SG"
    }
  )
}



# Launch Configuration
resource "aws_launch_configuration" "staging_config" {
  name          = "${local.name_prefix}-Config"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = var.type
  security_groups    = [aws_security_group.staging_lb_sg.id]
  key_name      = aws_key_pair.acs_key.key_name
  associate_public_ip_address = true
  iam_instance_profile = "LabInstanceProfile"
  user_data = filebase64("${path.module}/install_httpd.sh")
}

# Auto-Scaling-Group
resource "aws_autoscaling_group" "asg" {
  name               = "${local.name_prefix}-Asg"
  desired_capacity   = var.instance_count
  max_size           = 4
  min_size           = 1
  launch_configuration = aws_launch_configuration.staging_config.name
  vpc_zone_identifier       = [data.terraform_remote_state.network.outputs.private_subnet_id[0],data.terraform_remote_state.network.outputs.private_subnet_id[1],data.terraform_remote_state.network.outputs.private_subnet_id[2]]
  depends_on = [aws_lb.app_load_balancer]
  target_group_arns = [aws_lb_target_group.staging_lb.arn]

  tag{
      key = "Name"
      value = "staging-ec2-instance"
      propagate_at_launch = true
  }
}

    
 # ASG Policy to Scale Out
resource "aws_autoscaling_policy" "asg_scaleOutPolicy-dev" {
    name = "dev-asgPolicy-scaleOut"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm_scaleOut_dev" {
    alarm_name = "dev-alarm-ScaleOut"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "MemoryUtilization"
    namespace = "System/Linux"
    period = "120"
    statistic = "Average"
    threshold = "10"
    alarm_description = "This metric monitors ec2 memory for high utilization and deploy more instance if required"
    alarm_actions = [
        "${aws_autoscaling_policy.asg_scaleOutPolicy-dev.arn}"
    ]
    dimensions = {
        AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
    }
}

# ASG Policy to Scale in
resource "aws_autoscaling_policy" "asg_scaleInPolicy-dev" {
    name = "dev-asgPolicy-scaleIn"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 120
    autoscaling_group_name = "${aws_autoscaling_group.asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm_scaleIn_dev" {
    alarm_name = "dev-alarm-ScaleIn"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "MemoryUtilization"
    namespace = "System/Linux"
    period = "120"
    statistic = "Average"
    threshold = "5"
    alarm_description = "This metric monitors ec2 memory for low utilization on agent hosts"
    alarm_actions = [
        "${aws_autoscaling_policy.asg_scaleInPolicy-dev.arn}"
    ]
    dimensions = {
        AutoScalingGroupName = "${aws_autoscaling_group.asg.name}"
    }
}



# Bastion Host
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.type
  key_name                    = aws_key_pair.acs_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_id[1]
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-BastionHost"
    }
  )
}

# Adding SSH key to Amazon EC2
resource "aws_key_pair" "acs_key" {
  key_name   = local.name_prefix
  public_key = file("${local.name_prefix}.pub")
}

# Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh_bastion"
  description = "Allow SSH Inbount Traffic"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description      = "SSH From Admin"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Bastion_SG"
    }
  )
}

