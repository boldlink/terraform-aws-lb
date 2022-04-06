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
  description = "The environment this resource is being deployed to"
  type        = string
  default     = null
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type        = map(string)
  default     = {}
}

#####################################
### Target Group
#####################################

variable "target_group_connection_termination" {
  description = "(Optional) Whether to terminate connections at the end of the deregistration timeout on Network Load Balancers. See doc for more information. Default is false"
  type        = bool
  default     = false
}

variable "target_group_deregistration_delay" {
  description = "(Optional) Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  type        = number
  default     = 300
}

variable "target_group_health_check" {
  description = "Health Check configuration block for the target group"
  type        = map(string)
  default     = {}
}

variable "lambda_multi_value_headers_enabled" {
  description = "(Optional) Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target_type is lambda. Default is false"
  type        = bool
  default     = false
}

variable "target_group_load_balancing_algorithm_type" {
  description = "(Optional) Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is round_robin or least_outstanding_requests. The default is round_robin."
  type        = string
  default     = "round_robin"
}

variable "target_group_name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "target_group_name" {
  description = "(Optional, Forces new resource) Name of the target group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "target_group_port" {
  description = "(May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda."
  type        = string
  default     = null
}

variable "target_group_preserve_client_ip" {
  description = "Whether client IP preservation is enabled"
  type        = bool
  default     = false
}

variable "target_group_protocol_version" {
  description = "Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1"
  type        = string
  default     = "HTTP1"
}

variable "target_group_protocol" {
  description = "Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda"
  type        = string
  default     = null
}

variable "target_group_proxy_protocol_v2" {
  description = "Whether to enable support for proxy protocol v2 on Network Load Balancers."
  type        = bool
  default     = false
}

variable "target_group_slow_start" {
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds."
  type        = number
  default     = 0
}


variable "target_group_stickiness" {
  description = "Stickiness configuration block."
  type        = map(string)
  default     = {}
}

variable "target_group_tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group."
  type        = string
  default     = "instance"
}

variable "vpc_id" {
  description = "Identifier of the VPC in which to create the target group. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda."
  type        = string
  default     = null
}
