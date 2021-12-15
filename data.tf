data "aws_ssm_parameter" "coralogix_apikey" {
  name = "/infra/coralogix/apikey"
  with_decryption = true
}

data "aws_cloudwatch_log_group" "coralogix" {
 for_each = toset(var.loggroup_envs)
  name = "${var.app_name}-${each.key}"
}