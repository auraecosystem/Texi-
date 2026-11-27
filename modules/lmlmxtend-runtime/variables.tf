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
  description = "Private subnet IDs used by interface endpoints."

  validation {
    condition     = length(var.private_subnet_ids) > 0
    error_message = "At least one private subnet ID must be provided."
  }
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "Private route table IDs associated with the S3 gateway endpoint."

  validation {
    condition     = length(var.private_route_table_ids) > 0
    error_message = "At least one private route table ID must be provided."
  }
}

variable "ttl_hours" {
  type        = number
  default     = 24
  description = "Configured TTL in hours reported by the reaper."

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
