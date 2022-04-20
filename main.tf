#####################################
### Load Balancer
#####################################

resource "aws_lb" "main" {
  name                             = var.name
  name_prefix                      = var.name_prefix
  internal                         = var.internal
  load_balancer_type               = var.load_balancer_type
  security_groups                  = var.security_groups
  subnets                          = var.subnets
  enable_deletion_protection       = var.enable_deletion_protection
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  customer_owned_ipv4_pool         = var.customer_owned_ipv4_pool
  ip_address_type                  = var.ip_address_type

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", lookup(access_logs.value, "bucket", null) != null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags = merge(
    {
      "Name"        = var.name
      "Environment" = var.environment
    },
    var.other_tags,
  )
}
