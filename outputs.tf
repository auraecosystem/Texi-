output "vpc_id" {
  description = "ID of the runtime VPC."
  value       = aws_vpc.hub.id
}

output "private_subnet_ids" {
  description = "IDs of the private runtime subnets."
  value       = aws_subnet.private[*].id
}

output "runtime_role_id" {
  description = "ID of the runtime IAM role."
  value       = module.runtime.runtime_id
}

output "runtime_security_group_id" {
  description = "Security group ID for runtime workloads."
  value       = module.runtime.security_group_id
}

output "ttl_reaper_arn" {
  description = "ARN of the scheduled TTL reaper Lambda function."
  value       = module.runtime.reaper_arn
}
