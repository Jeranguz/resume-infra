output "github_actions_front_role_arn" {
  description = "ARN of the IAM role for GitHub Actions to deploy the frontend"
  value       = aws_iam_role.github_actions_front_role.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution for the frontend"
  value       = aws_cloudfront_distribution.frontend_distribution.id
}

output "frontend_bucket_name" {
  description = "Name of the S3 bucket for the frontend"
  value       = aws_s3_bucket.frontend.bucket
}

output "github_actions_back_role_arn" {
  description = "ARN of the IAM role for GitHub Actions to deploy the backend"
  value       = aws_iam_role.github_actions_back_role.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function for updating the visit counter"
  value       = aws_lambda_function.increase-counter.function_name
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = "${aws_apigatewayv2_stage.default.invoke_url}visitor"
}
