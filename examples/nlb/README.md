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

# Terraform module example showing configuration for network load balancer

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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_instances"></a> [ec2\_instances](#module\_ec2\_instances) | boldlink/ec2/aws | 2.0.4 |
| <a name="module_nlb"></a> [nlb](#module\_nlb) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ami.amazon_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.supporting](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | The architecture of the instance to launch | `string` | `"x86_64"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | The egress configuration for outgoing lb traffic | `any` | <pre>{<br>  "cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "from_port": 0,<br>  "protocol": "-1",<br>  "to_port": 0<br>}</pre> | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Whether to protect LB from deletion | `bool` | `false` | no |
| <a name="input_http_ingress"></a> [http\_ingress](#input\_http\_ingress) | The ingress configuration for lb security group http rule | `any` | <pre>{<br>  "cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "description": "allow http",<br>  "from_port": 80,<br>  "protocol": "tcp",<br>  "to_port": 80<br>}</pre> | no |
| <a name="input_https_ingress"></a> [https\_ingress](#input\_https\_ingress) | The ingress configuration for lb security group https rule | `any` | <pre>{<br>  "cidr_blocks": [<br>    "0.0.0.0/0"<br>  ],<br>  "description": "allow tls",<br>  "from_port": 443,<br>  "protocol": "tcp",<br>  "to_port": 443<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the stack | `string` | `"nlb-example"` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Configuration block to customize details about the root block device of the instance. | `list(any)` | <pre>[<br>  {<br>    "encrypted": true,<br>    "volume_size": 15<br>  }<br>]</pre> | no |
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
