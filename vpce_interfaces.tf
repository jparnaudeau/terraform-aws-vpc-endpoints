#####################################################################
# VPC Endpoints - Type Interface
#####################################################################
data "aws_vpc_endpoint_service" "vpce_service" {
  for_each     = { for tuple in var.vpcendpoints_interfaces : tuple.id => tuple }
  service      = each.key
  service_type = "Interface"
}

resource "aws_vpc_endpoint" "vpce" {
  for_each = { for tuple in var.vpcendpoints_interfaces : tuple.id => tuple }

  vpc_id              = lookup(each.value, "vpc_id")
  service_name        = data.aws_vpc_endpoint_service.vpce_service[each.key].service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = concat(try([aws_security_group.sg[each.key].id], []), lookup(each.value, "security_group_ids", []))
  subnet_ids          = lookup(each.value, "subnet_ids", [])
  private_dns_enabled = lookup(each.value, "private_dns_enabled", false)

  tags = merge(
    {
      "Name" = format(var.naming_pattern, "vpce", format("%s-endpoint", each.key))
    },
    lookup(each.value, "tags", []),
  )
}

resource "aws_security_group" "sg" {
  for_each = { for tuple in var.vpcendpoints_interfaces : tuple.id => tuple if tuple.create_security_group == true }

  name        = format(var.naming_pattern, "sg", format("%s-endpoint", each.key))
  description = format("Allow subnets access %s Endpoint", upper(each.key))
  vpc_id      = lookup(each.value, "vpc_id")

  dynamic "ingress" {
    for_each = lookup(each.value, "inbound_ports", ["443"])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      description = format("Allow subnets access %s Endpoint on port %s", upper(each.key), ingress.value)
      cidr_blocks = lookup(each.value, "allowed_cidr_blocks", [])
    }
  }

  tags = merge(
    {
      "Name" = format(var.naming_pattern, "sgr", format("%s-endpoint", each.key))
    },
    lookup(each.value, "tags", [])
  )
}
