variable "name" {
  description = "Input the name of stack"
  type        = string
  default     = null
}

variable "internal" {
  description = "Boolean, set the type of ip for the LB"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Set the App lb type, can be application or network"
  type        = string
  default     = "application"
}

variable "security_groups" {
  description = "The security group(s) of the LB"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "The subnets to listen from"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "Boolean, useful if you have multiple targets - avoids wide spread impact if deleted."
  type        = bool
  default     = false
}

variable "access_logs" {
  description = "Define an Access Logs block"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting load balancer resources"
  type        = map(string)
  default     = {}
}

variable "subnet_mapping" {
  description = "Define subnet mapping block"
  type        = map(string)
  default     = {}
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Default: 60"
  type        = string
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to `false`"
  type        = bool
  default     = false
}
variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers. Defaults to `true`" ##Application LB
  type        = bool
  default     = true
}
variable "customer_owned_ipv4_pool" {
  description = "The ID of the customer owned ipv4 pool to use for this load balancer."
  type        = string
  default     = null
}
variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with `name`"
  type        = string
  default     = null
}

/*
Tags
*/

variable "environment" {
  description = "The environemnt this resource is being deployed to"
  type        = string
  default     = null
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type        = map(string)
  default     = {}
}
