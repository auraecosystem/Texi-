data "archive_file" "reaper_zip" {
  type        = "zip"
  source_file = "${path.module}/reaper/index.py"
  output_path = "${path.module}/reaper/index.zip"
}

data "aws_iam_policy_document" "reaper_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "reaper" {
  name               = "${var.name_prefix}-reaper-role"
  assume_role_policy = data.aws_iam_policy_document.reaper_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "reaper_basic_logs" {
  role       = aws_iam_role.reaper.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "reaper" {
  function_name    = "${var.name_prefix}-ttl-reaper"
  role             = aws_iam_role.reaper.arn
  handler          = "index.handler"
  runtime          = "python3.12"
  filename         = data.archive_file.reaper_zip.output_path
  source_code_hash = data.archive_file.reaper_zip.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      TTL_HOURS = tostring(var.ttl_hours)
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "reaper_hourly" {
  name                = "${var.name_prefix}-reaper-hourly"
  description         = "Trigger TTL reaper every hour"
  schedule_expression = "rate(1 hour)"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "reaper_target" {
  rule      = aws_cloudwatch_event_rule.reaper_hourly.name
  target_id = "ttl-reaper-lambda"
  arn       = aws_lambda_function.reaper.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reaper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.reaper_hourly.arn
}
