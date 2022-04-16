#Add output variables
output "public_subnet_id" {
  value = module.vpc-staging.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc-staging.private_subnet_id
}

output "vpc_id" {
  value = module.vpc-staging.vpc_id
}

output "public_route_table_id" {
  value = module.vpc-staging.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc-staging.private_route_table_id
}
