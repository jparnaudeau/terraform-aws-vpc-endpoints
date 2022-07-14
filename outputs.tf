############################################
# outputs for vpc endpoints type Interface
############################################
output "vpc_endpoints_interface_infos" {
  description = "Informations regarding vpc endpoints type interface"
  value = {
    for tuple in var.vpcendpoints_interfaces : tuple.id => {
      vpc_endpoint_type     = "Interface"
      security_group_ids    = concat(try([aws_security_group.sg[tuple.id].id], []), try(tuple.security_group_ids, []))
      vpcendpoint_arn       = aws_vpc_endpoint.vpce[tuple.id].arn
      vpcendpoint_id        = aws_vpc_endpoint.vpce[tuple.id].id
      vpcendpoint_dns_entry = aws_vpc_endpoint.vpce[tuple.id].dns_entry
    }
  }
}

############################################
# outputs for vpc endpoints type Gateway
############################################
output "vpc_endpoints_gateway_infos" {
  description = "Informations regarding vpc endpoints type gateway"
  value = {
    for tuple in var.vpcendpoints_gateways : tuple.id => {
      vpc_endpoint_type          = "Gateway"
      route_table_ids            = tuple.route_table_ids
      vpcendpoint_arn            = aws_vpc_endpoint.vpce_gtw[tuple.id].arn
      vpcendpoint_id             = aws_vpc_endpoint.vpce_gtw[tuple.id].id
      vpcendpoint_prefix_list_id = aws_vpc_endpoint.vpce_gtw[tuple.id].prefix_list_id
      vpcendpoint_cidr_blocks    = aws_vpc_endpoint.vpce_gtw[tuple.id].cidr_blocks

    }
  }
}