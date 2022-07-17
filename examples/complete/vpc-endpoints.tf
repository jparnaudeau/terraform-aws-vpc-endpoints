locals {
  # Retrieve by a way or another these informations : 
  vpc_id                         = "vpc-06b39dd606d475307"
  private_backend_subnets_ids    = ["subnet-0bd166bcc6917cc15", "subnet-01b413241f1f69181", "subnet-0159d8a30ce664780"]
  private_backend_subnets_cidrs  = ["172.31.16.0/20", "172.31.0.0/20", "172.31.32.0/20"]
  private_backend_subnets_rt_ids = ["rtb-0e15c810631e634d9"]
}

################################################################################
# Deploy VPC Endpoints : 
# Interface : s3, kms, sns, ssm, ec2, cloudwatch (logs), cloudwatch(monitoring)
# Gateway   : s3, dynamodb
################################################################################
module "vpc-endpoints" {
  source = "../.."

  # set the environment
  region         = "eu-west-3"
  naming_pattern = "acme-dev-%s-%s" # keep 2 %s in this string

  ################### Declare Interface VPC Endpoints
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
    {
      id                    = "sns"
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
      id                    = "ssm"
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
      id                    = "ec2"
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
      id                    = "monitoring"
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
      id                    = "logs"
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

  ################### Declare Gateway VPC Endpoints
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
}
