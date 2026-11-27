locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

resource "aws_vpc" "hub" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-hub-vpc"
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.hub.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-private-${count.index + 1}"
  })
}

module "runtime" {
  source = "./modules/lmlmxtend-runtime"

  name_prefix        = local.name_prefix
  vpc_id             = aws_vpc.hub.id
  private_subnet_ids = aws_subnet.private[*].id
  runtime_type       = var.runtime_type
  ttl_hours          = var.ttl_hours
  tags               = local.common_tags
}
