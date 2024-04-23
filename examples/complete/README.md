[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-lb/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-lb.svg)](https://github.com/boldlink/terraform-aws-lb/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-lb/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-lb/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Terraform module example of complete configuration

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.46.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_access_logs_s3"></a> [access\_logs\_s3](#module\_access\_logs\_s3) | boldlink/s3/aws | n/a |
| <a name="module_authenticate_cognito"></a> [authenticate\_cognito](#module\_authenticate\_cognito) | ../../ | n/a |
| <a name="module_authenticate_oidc"></a> [authenticate\_oidc](#module\_authenticate\_oidc) | ../../ | n/a |
| <a name="module_complete"></a> [complete](#module\_complete) | ../../ | n/a |
| <a name="module_ec2_instances"></a> [ec2\_instances](#module\_ec2\_instances) | boldlink/ec2/aws | 2.0.4 |
| <a name="module_waf"></a> [waf](#module\_waf) | boldlink/waf/aws | 1.0.3 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [tls_private_key.main](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.main](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_enabled"></a> [access\_logs\_enabled](#input\_access\_logs\_enabled) | Whether access logs are enabled for the load balancer | `bool` | `true` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | The architecture of the instance to launch | `string` | `"x86_64"` | no |
| <a name="input_cloudwatch_metrics_enabled"></a> [cloudwatch\_metrics\_enabled](#input\_cloudwatch\_metrics\_enabled) | Whether to enable cloudwatch metrics | `bool` | `false` | no |
| <a name="input_create_ssl_certificate"></a> [create\_ssl\_certificate](#input\_create\_ssl\_certificate) | Whether to create ssl certificate with the module | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | The egress configuration for outgoing lb traffic | `any` | <pre>{<br>  "cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "from_port": 0,<br>  "protocol": "-1",<br>  "to_port": 0<br>}</pre> | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Whether to protect LB from deletion | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Whether to force deletion of the s3 bucket | `bool` | `true` | no |
| <a name="input_http_ingress"></a> [http\_ingress](#input\_http\_ingress) | The ingress configuration for lb security group http rule | `any` | <pre>{<br>  "cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "description": "allow http",<br>  "from_port": 80,<br>  "protocol": "tcp",<br>  "to_port": 80<br>}</pre> | no |
| <a name="input_https_ingress"></a> [https\_ingress](#input\_https\_ingress) | The ingress configuration for lb security group https rule | `any` | <pre>{<br>  "cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "description": "allow tls",<br>  "from_port": 443,<br>  "protocol": "tcp",<br>  "to_port": 443<br>}</pre> | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the created LB is internal or not | `bool` | `false` | no |
| <a name="input_listeners_configuration"></a> [listeners\_configuration](#input\_listeners\_configuration) | Configuration block for listeners | `any` | <pre>[<br>  {<br>    "default_actions": [<br>      {<br>        "fixed_response": {<br>          "content_type": "text/plain",<br>          "message_body": "Fixed message",<br>          "status_code": "200"<br>        },<br>        "type": "fixed-response"<br>      }<br>    ],<br>    "port": 443,<br>    "protocol": "HTTPS"<br>  },<br>  {<br>    "default_actions": [<br>      {<br>        "tg_index": 0,<br>        "type": "forward"<br>      }<br>    ],<br>    "port": 80,<br>    "protocol": "HTTP"<br>  }<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the stack | `string` | `"complete-alb-example"` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Configuration block to customize details about the root block device of the instance. | `list(any)` | <pre>[<br>  {<br>    "encrypted": true,<br>    "volume_size": 15<br>  }<br>]</pre> | no |
| <a name="input_sampled_requests_enabled"></a> [sampled\_requests\_enabled](#input\_sampled\_requests\_enabled) | Whether to enable simple requests | `bool` | `false` | no |
| <a name="input_supporting_resources_name"></a> [supporting\_resources\_name](#input\_supporting\_resources\_name) | Name of the supporting resources | `string` | `"terraform-aws-lb"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | <pre>{<br>  "Department": "DevOps",<br>  "Environment": "examples",<br>  "LayerId": "cExample",<br>  "LayerName": "cExample",<br>  "Owner": "Boldlink",<br>  "Project": "Examples",<br>  "user::CostCenter": "terraform-registry"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_outputs"></a> [outputs](#output\_outputs) | Output values for the module |
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

#### BOLDLink-SIG 2023
