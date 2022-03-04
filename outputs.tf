output "alb_id" {
  value       = aws_lb.main.id
  description = "The ARN of the load balancer (matches `arn`)."
}

output "alb_arn" {
  value       = aws_lb.main.arn
  description = "The ARN of the load balancer (matches `id`)."
}

output "alb_arn_suffix" {
  value       = aws_lb.main.arn_suffix
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the load balancer."
}

output "alb_zone_id" {
  value       = aws_lb.main.zone_id
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "alb_subnet_mapping_outpost_id" {
  value       = aws_lb.main.subnet_mapping.*.outpost_id
  description = "ID of the Outpost containing the load balancer."
}

output "alb_tags_all" {
  value       = aws_lb.main.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider `default_tags`."
}
