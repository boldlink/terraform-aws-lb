[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-lb/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-lb.svg)](https://github.com/boldlink/terraform-aws-lb/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# AWS Load Balancer Terraform module

## Description

This Terraform module is designed to facilitate the provisioning and configuration of Application, Network, and Gateway Load Balancers, Target Groups, and Load Balancer Listeners. It simplifies the process of creating and managing these resources, enabling efficient deployment and scaling.

## Why choose this module
- Ensures adherence to AWS security standards through the integration of checkov for code compliance scanning.
- Offers advanced functionality including:
  - Creation of single or multiple target groups for the load balancer
  - Creation of listeners with advanced features
  - Built-in security group with dynamic rule configuration capabilities
  - Built-in self-signed certificate support and the ability to integrate external certificates
- Provides ease of setup and utilization through clear instructions and examples.
- Streamlines the process of setting up load balancers and associated resources, leading to time and complexity savings.

Example available [here](./examples)

## Usage
**NOTE**: These examples use the latest version of this module

```hcl
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

module "minimum" {
  source             = "boldlink/lb/aws"
  name               = "minimum-example-lb"
  internal           = false
  subnets            = data.aws_subnets.default.ids
  security_groups    = [data.aws_security_group.default.id]
}
```

## Documentation

[AWS Application Load Balancer documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)

[Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.56.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [tls_private_key.main](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.main](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | (Optional) Define an Access Logs block | `map(string)` | `{}` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | Enter the ssl certificate common name, e.g "example.com" | `string` | `"boldlink.io"` | no |
| <a name="input_cert_organization"></a> [cert\_organization](#input\_cert\_organization) | The Organization which the certificate belongs to, e.g "Boldlink-SIG" | `string` | `"Boldlink-SIG"` | no |
| <a name="input_cert_validity_period_hours"></a> [cert\_validity\_period\_hours](#input\_cert\_validity\_period\_hours) | The number of hours the certificate is valid | `number` | `12` | no |
| <a name="input_create_ssl_certificate"></a> [create\_ssl\_certificate](#input\_create\_ssl\_certificate) | Choose whether to create ssl certificate | `bool` | `false` | no |
| <a name="input_customer_owned_ipv4_pool"></a> [customer\_owned\_ipv4\_pool](#input\_customer\_owned\_ipv4\_pool) | (Optional) The ID of the customer owned ipv4 pool to use for this load balancer. | `string` | `null` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | (Optional) Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are monitor, defensive (default), strictest. | `string` | `"defensive"` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | (Optional)Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (true) or routed to targets (false). The default is false | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | (Optional) Egress rules to add to the security group | `any` | `{}` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | (Optional) If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to `false` | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | (Optional) If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `true` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | (Optional) Indicates whether HTTP/2 is enabled in application load balancers. Defaults to `true` | `bool` | `true` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Default: 60 | `string` | `60` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | (Optional) Ingress rules to add to the security group | `any` | `{}` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | (Optional) If true, the LB will be internal. | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | (Optional) The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack` | `string` | `null` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | A list of maps describing the listeners for the LB | `any` | `[]` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Set the App lb type, can be application or network | `string` | `"application"` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen. If not specified, Terraform will autogenerate a name beginning with tf-lb. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Creates a unique name beginning with the specified prefix. Conflicts with `name` | `string` | `null` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | (Optional) A list of security group IDs to assign to the LB. Only valid for Load Balancers of type application. | `list(string)` | `[]` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | (Optional) Define subnet mapping block | `map(string)` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Optional) A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type network. Changing this value for load balancers of type network will force a recreation of the resource. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | A list of maps describing the target groups for the LB | `any` | `[]` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) Define maximum timeout for creating, updating, and deleting load balancer resources | `any` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifier of the VPC in which to create the target group. Required when target\_type is instance, ip or alb. Does not apply when target\_type is lambda. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name of the target group |
| <a name="output_arn_suffix"></a> [arn\_suffix](#output\_arn\_suffix) | ARN suffix for use with CloudWatch Metrics. |
| <a name="output_id"></a> [id](#output\_id) | ARN of the Target Group (matches `arn`) |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | The ARN of the load balancer (matches `id`). |
| <a name="output_lb_arn_suffix"></a> [lb\_arn\_suffix](#output\_lb\_arn\_suffix) | The ARN suffix for use with CloudWatch Metrics. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | The DNS name of the load balancer. |
| <a name="output_lb_id"></a> [lb\_id](#output\_lb\_id) | The ARN of the load balancer (matches `arn`). |
| <a name="output_lb_subnet_mapping_outpost_id"></a> [lb\_subnet\_mapping\_outpost\_id](#output\_lb\_subnet\_mapping\_outpost\_id) | ID of the Outpost containing the load balancer. |
| <a name="output_lb_tags_all"></a> [lb\_tags\_all](#output\_lb\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider `default_tags`. |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | ARN of the listener (matches `id`). |
| <a name="output_listener_id"></a> [listener\_id](#output\_listener\_id) | ARN of the listener (matches `arn`). |
| <a name="output_listener_tags_all"></a> [listener\_tags\_all](#output\_listener\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_name"></a> [name](#output\_name) | Name of the Target Group. |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

### Supporting resources:

The example stacks are used by BOLDLink developers to validate the modules by building an actual stack on AWS.

Some of the modules have dependencies on other modules (ex. Ec2 instance depends on the VPC module) so we create them
first and use data sources on the examples to use the stacks.

Any supporting resources will be available on the `tests/supportingResources` and the lifecycle is managed by the `Makefile` targets.

Resources on the `tests/supportingResources` folder are not intended for demo or actual implementation purposes, and can be used for reference.

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done separately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```
* !!!DANGER!!! Clean the state files from examples and test/supportingResources - use with CAUTION!!!
```console
make cleanstatefiles
```


#### BOLDLink-SIG 2023
