# terraform-aws-vpc-endpoints

This module provides an unified way to deploy vpc endpoints (interface & gateway).

Refer to the [examples](examples/complete) directory for more details.

## VPC Endpoint - type Interface

You could find a complete list of AWS Services that integrate **Interface VPC Endpoint** [here](https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html). 

Each VPC Endpoint for a particular AWS Service have an unique identifier. Check the column `Service name` in the following [link](https://docs.aws.amazon.com/vpc/latest/privatelink/aws-services-privatelink-support.html).

This identifier corresponds to the input variable `id` for the module.

The **Interface VPC Endpoint** is a VPC Endpoint implemented by the creation of `ENI` (Elastic Network Interface) inside the subnets where the VPC endpoint is associated with. Because there is ENI, it could be possible to restrict the flows by using security group.
you can decide to let the module create the security group for you, or pass it as input to the module.
Use `create_security_group` to `true` if you let the module generate the security group for you, or use `security_group_ids` to pass existent security groups. The inbound port should be opened for the `https` protocol.

```
locals {
    vpc_id                        = "vpc-0123456789"
    private_backend_subnets_ids   = ["subnet-0bd166bcc6917cc16","subnet-01b413241f1f69186","subnet-0159d8a30ce664786"] 
    private_backend_subnets_cidrs = ["172.31.16.0/20","172.31.0.0/20","172.31.32.0/20"] 
}

module "vpc-endpoints" {
  source  = "jparnaudeau/vpc-endpoints/aws"
  version = "1.0.0"

  # set the environment
  region         = var.region
  naming_pattern = "acme-dev-%s-%s"

  vpcendpoints_interfaces = [
    {
      id                    = "s3"
      vpc_id                = local.vpc_id
      subnet_ids            = local.private_backend_subnets_ids
      create_security_group = true
      security_group_ids    = []
      private_dns_enabled   = false
      allowed_cidr_blocks   = local.private_backend_subnets_cidrs
      inbound_ports         = ["443"]
      tags = {
        Component = "myapp"
      }
    },
    {
      id                    = "kms"
      vpc_id                = local.vpc_id
      subnet_ids            = local.private_backend_subnets_ids
      create_security_group = true
      security_group_ids    = []
      private_dns_enabled   = false
      allowed_cidr_blocks   = local.private_backend_subnets_cidrs
      inbound_ports         = ["443"]
      tags = {
        Component = "myapp"
      }
    },
  ]

```

## VPC Endpoint - type Gateway

The **Gateway VPC Endpoint** is described in this [link](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html).

Gateway endpoints provide reliable connectivity to Amazon S3 and DynamoDB without requiring an internet gateway or a NAT device for your VPC. Gateway endpoints do not enable AWS PrivateLink.

It is implemented by the creation of an `AWS Prefix List`, directly used inside the route table of the subnets in which the VPC endpoint is attached with.

```
locals {
    vpc_id                         = "vpc-0123456789"
    private_backend_subnets_rt_ids = ["rtb-0e15c810631e634d6"]
}

module "vpc-endpoints" {
  source  = "jparnaudeau/vpc-endpoints/aws"
  version = "1.0.0"

  # set the environment
  region         = var.region
  naming_pattern = "acme-dev-%s-%s"

  vpcendpoints_gateways = [
    {
      id                  = "s3"
      vpc_id              = local.vpc_id
      private_dns_enabled = false
      route_table_ids     = local.private_backend_subnets_rt_ids
      tags = {
        Component = "myapp"
      }
    },
    {
      id                  = "dynamodb"
      vpc_id              = local.vpc_id
      private_dns_enabled = false
      route_table_ids     = local.private_backend_subnets_rt_ids
      tags = {
        Component = "myapp"
      }
    },
  ]

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.vpce](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.vpce_gtw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_service.vpce_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.vpce_service_gtw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_naming_pattern"></a> [naming\_pattern](#input\_naming\_pattern) | The naming pattern to apply for the name of the resource vpc\_endpoint and security\_group. Must contains 2 %s | `string` | `"project-environment-%s-%s"` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region Id | `string` | `"eu-west-3"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | a map of string containing the tags | `map(string)` | `{}` | no |
| <a name="input_vpcendpoints_gateways"></a> [vpcendpoints\_gateways](#input\_vpcendpoints\_gateways) | a map of object for creating vpcendpoints type gatewy (s3,dynamodb,...) | <pre>list(object({<br>    id              = string<br>    vpc_id          = string<br>    route_table_ids = list(string)<br>    tags            = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_vpcendpoints_interfaces"></a> [vpcendpoints\_interfaces](#input\_vpcendpoints\_interfaces) | a map of object for creating vpcendpoints type interface (s3,kms,sns,...) | <pre>list(object({<br>    id                    = string<br>    vpc_id                = string<br>    subnet_ids            = list(string)<br>    create_security_group = bool<br>    security_group_ids    = list(string)<br>    private_dns_enabled   = bool<br>    allowed_cidr_blocks   = list(string)<br>    inbound_ports         = list(string)<br>    tags                  = map(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_endpoints_gateway_infos"></a> [vpc\_endpoints\_gateway\_infos](#output\_vpc\_endpoints\_gateway\_infos) | Informations regarding vpc endpoints type gateway |
| <a name="output_vpc_endpoints_interface_infos"></a> [vpc\_endpoints\_interface\_infos](#output\_vpc\_endpoints\_interface\_infos) | Informations regarding vpc endpoints type interface |
