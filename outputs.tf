# Load balancer
output "lb_id" {
  value       = aws_lb.main.id
  description = "The ARN of the load balancer (matches `arn`)."
}

output "lb_arn" {
  value       = aws_lb.main.arn
  description = "The ARN of the load balancer (matches `id`)."
}

output "lb_arn_suffix" {
  value       = aws_lb.main.arn_suffix
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "lb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the load balancer."
}

output "lb_zone_id" {
  value       = aws_lb.main.zone_id
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "lb_subnet_mapping_outpost_id" {
  value       = aws_lb.main.subnet_mapping.*.outpost_id
  description = "ID of the Outpost containing the load balancer."
}

output "lb_tags_all" {
  value       = aws_lb.main.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider `default_tags`."
}

# Target Group
output "arn_suffix" {
  value       = aws_lb_target_group.main.*.arn_suffix
  description = "ARN suffix for use with CloudWatch Metrics."
}

output "arn" {
  value       = aws_lb_target_group.main.*.arn
  description = "The Amazon Resource Name of the target group"
}

output "id" {
  value       = aws_lb_target_group.main.*.id
  description = "ARN of the Target Group (matches `arn`)"
}

output "name" {
  value       = aws_lb_target_group.main.*.name
  description = "Name of the Target Group."
}

output "tags_all" {
  value       = aws_lb_target_group.main.*.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}

# Listener
output "listener_arn" {
  value       = aws_lb_listener.main.*.arn
  description = "ARN of the listener (matches `id`)."
}

output "listener_id" {
  value       = aws_lb_listener.main.*.id
  description = "ARN of the listener (matches `arn`)."
}

output "listener_tags_all" {
  value       = aws_lb_listener.main.*.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}

# Security group
output "sg_id" {
  value       = join("", aws_security_group.main[*].id)
  description = "The Id of the created security group"
}
