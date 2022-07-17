output "available_vpc_endpoints_interface" {
  description = "outputs related to VPC Endpoints (type Interface) available in the Account"
  value       = module.vpc-endpoints.vpc_endpoints_interface_infos
}

output "available_vpc_endpoints_gateway" {
  description = "outputs related to VPC Endpoints (type Gateway) available in the Account"
  value       = module.vpc-endpoints.vpc_endpoints_gateway_infos
}