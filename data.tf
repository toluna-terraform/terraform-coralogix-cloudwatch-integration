data "aws_ssm_parameter" "coralogix_apikey" {
  name = "/infra/coralogix/apikey"
  with_decryption = true
}
