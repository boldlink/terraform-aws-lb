# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
- Showcase more feature usage in example
- Add examples for other types of load balancers
- Fix: CKV2_AWS_28  #Ensure public facing ALB are protected by WAF
- Add instance target type example
- Add Lambda function target type example
- Feature: Listener rules
- Feature: Target group attachment
- Feature: use acm module for acm certificate in examples

## [1.08] - 2023-01-25
### Description
- Fix: CKV_AWS_131  #Ensure that ALB drops HTTP headers
- Fix: CKV_AWS_91  #Ensure the ELBv2 (Application/Network) has access logging enabled
- feat: add latest workflow files

## [1.0.7] - 2022-10-20
### Description
- Fix: CKV_AWS_2  #Ensure ALB protocol is HTTPS
- Fix: CKV_AWS_103  #Ensure that load balancer is using TLS 1.2
- feat: Add supporting resources
- feat: add updated files from template repo

## [1.0.6] - 2022-07-05
### Description
- Feature: Consolidated sub-module and the main module
- Feature: Add security group for the load balancer
- Updated variable descriptions
- Feature; create multiple target groups
- CKV_AWS_233 checkov fix

## [1.0.5] - 2022-06-23
### Changes
- Added the `.github/workflow` folder (not supposed to run gitcommit)
- Re-factored examples (`minimum`, `complete` and additional)
- Added `CHANGELOG.md`
- Added `CODEOWNERS`
- Added `versions.tf`, which is important for pre-commit checks
- Added `Makefile` for examples automation
- Added `.gitignore` file

## [1.0.4] - 2022-04-29
### Changes
Fix: Renamed repository from 'alb' to 'lb'
Restructured the example

## [1.0.3] - 2022-04-20
### Changes
Feature: Added target group
Feature: Added listeners
Feature: Added listener certificate

## [1.0.2] - 2022-04-20
### Changes
- Modified access_logs feature block

## [1.0.1] - 2022-03-04
### Changes
- Made some modifications on README

## [1.0.0] - 2022-03-04
### Changes
- Initial commit

[Unreleased]: https://github.com/boldlink/terraform-aws-lb/compare/1.0.8...HEAD

[1.0.8]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.8
[1.0.7]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.7
[1.0.6]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.6
[1.0.5]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.5
[1.0.4]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.4
[1.0.3]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.3
[1.0.2]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.2
[1.0.1]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.1
[1.0.0]: https://github.com/boldlink/terraform-aws-lb/releases/tag/1.0.0
