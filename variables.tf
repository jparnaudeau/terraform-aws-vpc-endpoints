variable "region" {
  description = "The AWS Region Id"
  type        = string
  default     = "eu-west-3"
}

variable "tags" {
  description = "a map of string containing the tags"
  type        = map(string)
  default     = {}
}


variable "naming_pattern" {
  description = "The naming pattern to apply for the name of the resource vpc_endpoint and security_group. Must contains 2 %s"
  type        = string
  default     = "project-environment-%s-%s"
}

####################################
# variables for endpoints type interface
####################################
variable "vpcendpoints_interfaces" {
  description = "a map of object for creating vpcendpoints type interface (s3,kms,sns,...)"
  type = list(object({
    id                    = string
    vpc_id                = string
    subnet_ids            = list(string)
    create_security_group = bool
    security_group_ids    = list(string)
    private_dns_enabled   = bool
    allowed_cidr_blocks   = list(string)
    inbound_ports         = list(string)
    tags                  = map(string)
  }))
  default = []
}

####################################
# variables for endpoints type gateway
####################################
variable "vpcendpoints_gateways" {
  description = "a map of object for creating vpcendpoints type gateway (s3,dynamodb,...)"
  type = list(object({
    id              = string
    vpc_id          = string
    route_table_ids = list(string)
    tags            = map(string)
  }))
  default = []
}
