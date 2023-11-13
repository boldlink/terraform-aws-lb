module "waf" {
  source      = "boldlink/waf/aws"
  version     = "1.0.3"
  description = "WAF rules for ${var.name}"
  name        = var.name
  tags        = local.tags

  custom_response_bodies = [
    {
      key          = "custom_response_body_1",
      content      = "You are not authorized to access this resource.",
      content_type = "TEXT_PLAIN"
    }
  ]

  default_action = "allow"

  rules = [
    {
      name = "${var.name}-none-override"

      override_action = {
        none = {}
      }

      priority = 5

      statement = {
        managed_rule_group_statement = {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config = {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                = "${var.name}-count-override"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  ]
}
