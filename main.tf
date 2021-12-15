
resource "aws_iam_role" "coralogix" {
  name = "lambda-coralogix-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "coralogix" {
  name        = "lambda-coralogix-policy"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.coralogix.name
  policy_arn = aws_iam_policy.coralogix.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "coralogix" {
  filename         = "${path.module}/lambda.zip"
  function_name    = "coralogix-cloudwatch-forwarder-${var.app_name}"
  role             = "${aws_iam_role.coralogix.arn}"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  environment {
    variables = {
      CORALOGIX_URL = "api.coralogix.com"
      app_name = var.app_name
      buffer_charset = "utf8"
      newline_pattern =	"(?:\\r\\n|\\r|\\n)"
      private_key	= "${data.aws_ssm_parameter.coralogix_apikey.value}"
      sampling	= 1
      sub_name	= var.app_name
    }
  }

  depends_on = [
    aws_iam_role.coralogix
  ]
}

resource "null_resource" "remove_zip" {
  provisioner "local-exec" {
    when = create
    command = "rm -f ${path.module}/lambda.zip"
  }
  depends_on = [aws_lambda_function.coralogix]
}

resource "aws_lambda_permission" "coralogix-allow-cloudwatch" {
  for_each = toset(var.loggroup_envs)
    statement_id  = "coralogix-allow-cloudwatch-${each.key}"
    action        = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.coralogix.arn}"
    principal     = "logs.${var.region}.amazonaws.com"
    source_arn    = data.aws_cloudwatch_log_group.coralogix[each.key].arn
}

resource "aws_cloudwatch_log_subscription_filter" "coralogix" {
  for_each = toset(var.loggroup_envs)
    name            = "${each.key}"
    log_group_name  = "${var.app_name}-${each.key}"
    filter_pattern  = ""
    destination_arn = aws_lambda_function.coralogix.arn
}