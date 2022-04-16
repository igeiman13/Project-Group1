#Add output variables
output "public_subnet_id" {
  value = module.vpc-prod.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc-prod.private_subnet_id
}

output "vpc_id" {
  value = module.vpc-prod.vpc_id
}

output "public_route_table_id" {
  value = module.vpc-prod.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc-prod.private_route_table_id
}
