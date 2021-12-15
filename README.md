Lambda to forward logs from cloudwatch to coralogix [Terraform module](https://registry.terraform.io/modules/toluna-terraform/terraform-coralogix-cloudwatch-integration/latest)

### Description
This module implement forwarding cloudwatch logs to coralogix.

\* **an environment equals in it's name to the Terraform workspace it runs under so when referring to an environment or workspace throughout this document their value is actually the same.**



The following resources will be created:
- Lambda
- Role and Policy for the Lambda
- Log Group triggers for Lambda

## Requirements
The module requires some pre conditions
#### Minimum requirements:
- Pre defined SSM Parameter: "/infra/coralogix/apikey

## Usage
```hcl
module "coralogix" {
  source                      = "toluna-terraform/terraform-coralogix-cloudwatch-integration"
  app_name                    = local.app_name
  loggroup_envs               = local.loggroup_envs
  region                      = "us-east-1"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.59 |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.59 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="coralogix"></a> [coralogix](#module\coralogix) | ../../ |  |

## Resources

| Name | Type |
|------|------|
resource |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_iam_role) | resource |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_iam_policy) | resource |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_iam_role_policy_attachment) | resource |
| [aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_lambda_function) | resource |
| [aws_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_lambda_permission) | resource |
| [aws_cloudwatch_log_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_cloudwatch_log_subscription_filter) | resource |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

No inputs.

## Outputs
No outputs.

