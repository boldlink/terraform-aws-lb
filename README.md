# AWS Application Load Balancer Terraform module

## Description

This terraform module creates an Application Load Balancer

Example available [here](https://github.com/boldlink/terraform-aws-alb/tree/main/examples/main.tf)

## Documentation

[AWS Application Load Balancer documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)

[Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | Define an Access Logs block | `map(string)` | `{}` | no |
| <a name="input_customer_owned_ipv4_pool"></a> [customer\_owned\_ipv4\_pool](#input\_customer\_owned\_ipv4\_pool) | The ID of the customer owned ipv4 pool to use for this load balancer. | `string` | `null` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false | `bool` | `false` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to `false` | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Boolean, useful if you have multiple targets - avoids wide spread impact if deleted. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Indicates whether HTTP/2 is enabled in application load balancers. Defaults to `true` | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment this resource is being deployed to | `string` | `null` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Default: 60 | `string` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Boolean, set the type of ip for the LB | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack` | `string` | `null` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Set the App lb type, can be application or network | `string` | `"application"` | no |
| <a name="input_name"></a> [name](#input\_name) | Input the name of stack | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with `name` | `string` | `null` | no |
| <a name="input_other_tags"></a> [other\_tags](#input\_other\_tags) | For adding an additional values for tags | `map(string)` | `{}` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The security group(s) of the LB | `list(string)` | `[]` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | Define subnet mapping block | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets to listen from | `list(string)` | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting load balancer resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | The ARN of the load balancer (matches `id`). |
| <a name="output_alb_arn_suffix"></a> [alb\_arn\_suffix](#output\_alb\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics. |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_alb_id"></a> [alb\_id](#output\_alb\_id) | The ARN of the load balancer (matches `arn`). |
| <a name="output_alb_subnet_mapping_outpost_id"></a> [alb\_subnet\_mapping\_outpost\_id](#output\_alb\_subnet\_mapping\_outpost\_id) | ID of the Outpost containing the load balancer. |
| <a name="output_alb_tags_all"></a> [alb\_tags\_all](#output\_alb\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider `default_tags`. |
| <a name="output_alb_zone_id"></a> [alb\_zone\_id](#output\_alb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
