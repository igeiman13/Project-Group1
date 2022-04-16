#Add output variables
output "public_subnet_id" {
  value = module.vpc-dev.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc-dev.private_subnet_id
}

output "vpc_id" {
  value = module.vpc-dev.vpc_id
}

output "public_route_table_id" {
  value = module.vpc-dev.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc-dev.private_route_table_id
}
