#####################################################################
# VPC Endpoints - Type Gateway
#####################################################################
locals {
  # iterate over vpc endpoint gateways nested to the list of route table id
  route_table_ids = flatten([
    for tuple in var.vpcendpoints_gateways : [
      for rt in tuple.route_table_ids : {
        vpc_endpoint_id = tuple.id
        route_table_id  = rt
      }
    ]
  ])
}

data "aws_vpc_endpoint_service" "vpce_service_gtw" {
  for_each     = { for tuple in var.vpcendpoints_gateways : tuple.id => tuple }
  service      = each.key
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "vpce_gtw" {
  for_each = { for tuple in var.vpcendpoints_gateways : tuple.id => tuple }

  vpc_id       = lookup(each.value, "vpc_id")
  service_name = data.aws_vpc_endpoint_service.vpce_service_gtw[each.key].service_name
  tags = merge(
    {
      "Name" = format(var.naming_pattern, "vpce", format("%s-gateway-endpoint", each.key))
    },
    lookup(each.value, "tags", []),
  )
}

resource "aws_vpc_endpoint_route_table_association" "rt_assoc" {
  for_each = { for k in local.route_table_ids : format("%s-%s", k.route_table_id, k.vpc_endpoint_id) =>
    {
      vpce_id = k.vpc_endpoint_id
      rt_id   = k.route_table_id
    }
  }

  vpc_endpoint_id = aws_vpc_endpoint.vpce_gtw[each.value["vpce_id"]].id
  route_table_id  = each.value["rt_id"]
}
