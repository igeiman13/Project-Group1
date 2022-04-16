#Add output variables

output "lb_dns_name" {
  value       = aws_lb.app_load_balancer.dns_name
}

