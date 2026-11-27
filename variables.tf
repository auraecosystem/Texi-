variable "aws_region" {
  type        = string
  description = "AWS region for the Texinfo runtime infrastructure."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name used in resource names and tags."
  default     = "texinfo"
}

variable "environment" {
  type        = string
  description = "Deployment environment."
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the runtime VPC."
  default     = "10.20.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private runtime subnets."
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) > 0
    error_message = "At least one private subnet CIDR is required."
  }
}

variable "ttl_hours" {
  type        = number
  description = "Hours before an EC2 instance tagged with ExpiresAt is terminated."
  default     = 24

  validation {
    condition     = var.ttl_hours >= 1 && var.ttl_hours <= 720
    error_message = "ttl_hours must be between 1 and 720."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags applied to infrastructure resources."
  default     = {}
}
