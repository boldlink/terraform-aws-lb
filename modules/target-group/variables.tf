#####################################
### Target Group
#####################################

variable "connection_termination" {
  description = "(Optional) Whether to terminate connections at the end of the deregistration timeout on Network Load Balancers. See doc for more information. Default is false"
  type        = bool
  default     = false
}

variable "deregistration_delay" {
  description = "(Optional) Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. The default value is 300 seconds."
  type        = number
  default     = 300
}

variable "health_check" {
  description = "Health Check configuration block for the target group"
  type        = map(string)
  default     = {}
}

variable "lambda_multi_value_headers_enabled" {
  description = "(Optional) Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target_type is lambda. Default is false"
  type        = bool
  default     = false
}

variable "load_balancing_algorithm_type" {
  description = "(Optional) Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups. The value is round_robin or least_outstanding_requests. The default is round_robin."
  type        = string
  default     = "round_robin"
}

variable "name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "name" {
  description = "(Optional, Forces new resource) Name of the target group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "port" {
  description = "(May be required, Forces new resource) Port on which targets receive traffic, unless overridden when registering a specific target. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda."
  type        = string
  default     = null
}

variable "preserve_client_ip" {
  description = "Whether client IP preservation is enabled"
  type        = bool
  default     = false
}

variable "protocol_version" {
  description = "Only applicable when protocol is HTTP or HTTPS. The protocol version. Specify GRPC to send requests to targets using gRPC. Specify HTTP2 to send requests to targets using HTTP/2. The default is HTTP1, which sends requests to targets using HTTP/1.1"
  type        = string
  default     = "HTTP1"
}

variable "protocol" {
  description = "Protocol to use for routing traffic to the targets. Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP. Required when target_type is instance, ip or alb. Does not apply when target_type is lambda"
  type        = string
  default     = null
}

variable "proxy_protocol_v2" {
  description = "Whether to enable support for proxy protocol v2 on Network Load Balancers."
  type        = bool
  default     = false
}

variable "slow_start" {
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds."
  type        = number
  default     = 0
}


variable "stickiness" {
  description = "Stickiness configuration block."
  type        = map(string)
  default     = {}
}

variable "tags" {
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
