variable "name_prefix" {
  type        = string
  description = "Prefix applied to module resources."
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID for security groups and VPC endpoints."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for compute and interface endpoints."

  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "At least one private subnet ID must be provided."
  }
}

variable "runtime_type" {
  type        = string
  default     = "lambda"
  description = "Compute runtime mode: ec2, ecs_fargate, or lambda."

  validation {
    condition     = contains(["ec2", "ecs_fargate", "lambda"], var.runtime_type)
    error_message = "runtime_type must be one of: ec2, ecs_fargate, lambda."
  }
}

variable "ttl_hours" {
  type        = number
  default     = 24
  description = "Time-to-live duration in hours before tagged resources expire."

  validation {
    condition     = var.ttl_hours >= 1 && var.ttl_hours <= 720
    error_message = "ttl_hours must be between 1 and 720."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags applied to created resources."
}
