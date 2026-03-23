resource "aws_dynamodb_table" "visit_counter" {
  name         = "cloud-resume-challenge"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "initial_count" {
  table_name = aws_dynamodb_table.visit_counter.name
  hash_key   = aws_dynamodb_table.visit_counter.hash_key

  item = <<ITEM
    {
        "id": {"S": "visit_count"},
        "count": {"N": "0"}
    }
    ITEM
}

resource "aws_lambda_function" "increase-counter" {
  function_name = "increaseCounter"
  role          = aws_iam_role.lambda-update-counter.arn
  runtime       = "python3.14"
  handler       = "lambda_function.lambda_handler"

  filename         = data.archive_file.lambda_placeholder.output_path
  source_code_hash = data.archive_file.lambda_placeholder.output_base64sha256
}

data "archive_file" "lambda_placeholder" {
  type        = "zip"
  output_path = "${path.module}/placeholder.zip"

  source {
    content  = "def lambda_handler(event, context): pass"
    filename = "lambda_function.py"
  }
}

resource "aws_apigatewayv2_api" "visitor-counter-api" {
  name          = "UpdateCount"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["https://${var.domain_name}", "https://www.${var.domain_name}"]
    allow_methods = ["GET"]
    allow_headers = ["content-type"]
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.visitor-counter-api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda-integration" {
  api_id                 = aws_apigatewayv2_api.visitor-counter-api.id
  integration_uri        = aws_lambda_function.increase-counter.invoke_arn
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "increase-counter-route" {
  api_id    = aws_apigatewayv2_api.visitor-counter-api.id
  route_key = "GET /visitor"
  target    = "integrations/${aws_apigatewayv2_integration.lambda-integration.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.increase-counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitor-counter-api.execution_arn}/*/*"
}
