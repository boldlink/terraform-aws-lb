######################
#### Target Group
######################
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

######################
#### Listener
######################
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
