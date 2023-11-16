variable "name" {
  type        = string
  description = "Name of the stack"
  default     = "nlb-example"
}

variable "supporting_resources_name" {
  type        = string
  description = "Name of the supporting resources"
  default     = "terraform-aws-lb"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default = {
    Environment        = "examples"
    "user::CostCenter" = "terraform-registry"
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}

variable "root_block_device" {
  description = "Configuration block to customize details about the root block device of the instance."
  type        = list(any)
  default = [
    {
      volume_size = 15
      encrypted   = true
    }
  ]
}

variable "architecture" {
  type        = string
  description = "The architecture of the instance to launch"
  default     = "x86_64"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether to protect LB from deletion"
  default     = false
}

variable "https_ingress" {
  type        = any
  description = "The ingress configuration for lb security group https rule"
  default = {
    description = "allow tls"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "http_ingress" {
  type        = any
  description = "The ingress configuration for lb security group http rule"
  default = {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "egress_rules" {
  type        = any
  description = "The egress configuration for outgoing lb traffic"
  default = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
