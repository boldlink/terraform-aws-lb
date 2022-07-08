# Load balancer
variable "name" {
  description = "(Optional) The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. If not specified, Terraform will autogenerate a name beginning with tf-lb."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with `name`"
  type        = string
  default     = null
}

variable "internal" {
  description = "(Optional) If true, the LB will be internal."
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Set the App lb type, can be application or network"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "(Optional) A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application."
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "(Optional) A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource."
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "(Optional) If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = true
}

variable "access_logs" {
  description = "(Optional) Define an Access Logs block"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "(Optional) Define maximum timeout for creating, updating, and deleting load balancer resources"
  type        = map(string)
  default     = {}
}

variable "subnet_mapping" {
  description = "(Optional) Define subnet mapping block"
  type        = map(string)
  default     = {}
}

variable "drop_invalid_header_fields" {
  description = "(Optional)Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Default: 60"
  type        = string
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "(Optional) If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to `false`"
  type        = bool
  default     = false
}
variable "enable_http2" {
  description = "(Optional) Indicates whether HTTP/2 is enabled in application load balancers. Defaults to `true`" ##Application LB
  type        = bool
  default     = true
}
variable "customer_owned_ipv4_pool" {
  description = "(Optional) The ID of the customer owned ipv4 pool to use for this load balancer."
  type        = string
  default     = null
}

variable "ip_address_type" {
  description = "(Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`"
  type        = string
  default     = null
}

variable "desync_mitigation_mode" {
  description = "(Optional) Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are monitor, defensive (default), strictest."
  type        = string
  default     = "defensive"
}

# Tags
variable "tags" {
  description = "(Optional) A map of tags to assign to the resource. "
  type        = map(string)
  default     = {}
}


# Target Group
variable "target_groups" {
  description = "A list of maps describing the target groups for the LB"
  type        = any
  default     = []
}

variable "vpc_id" {
  description = "Identifier of the VPC in which to create the target group. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda."
  type        = string
  default     = null
}

# Listener
variable "listeners" {
  description = "A list of maps describing the listeners for the LB"
  type        = any
  default     = []
}

variable "cert_common_name" {
  description = "Enter the ssl certificate common name, e.g \"example.com\""
  type        = string
  default     = "boldlink.io"
}

variable "cert_organization" {
  description = "The Organization which the certificate belongs to, e.g \"Boldlink-SIG\""
  type        = string
  default     = "Boldlink-SIG"
}

variable "cert_validity_period_hours" {
  description = "The number of hours the certificate is valid"
  type        = number
  default     = 12
}

variable "create_ssl_certificate" {
  description = "Choose whether to create ssl certificate"
  type        = bool
  default     = false
}

# Security group

variable "ingress_rules" {
  description = "(Optional) Ingress rules to add to the security group"
  type        = any
  default     = {}
}
variable "egress_rules" {
  description = "(Optional) Egress rules to add to the security group"
  type        = any
  default     = {}
}
