output "runtime_id" {
  value       = aws_iam_role.runtime.id
  description = "Identifier of the runtime IAM role."
}

output "security_group_id" {
  value       = aws_security_group.runtime.id
  description = "Security group ID attached to runtime workloads."
}

output "reaper_arn" {
  value       = aws_lambda_function.reaper.arn
  description = "ARN of the TTL reaper Lambda function."
}

output "expires_at" {
  value       = timeadd(timestamp(), "${var.ttl_hours}h")
  description = "Estimated expiration timestamp based on ttl_hours."
}
