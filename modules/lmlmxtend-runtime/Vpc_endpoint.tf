data "aws_region" "current" {}

locals {
  interface_services = toset(["ssm", "ecr.api", "ecr.dkr", "logs"])
}

resource "aws_security_group" "vpce" {
  name_prefix = "${var.name_prefix}-vpce-"
  description = "Allow HTTPS traffic from private subnets to interface endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.runtime.id]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpce-sg"
  })
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.interface_services

  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${replace(each.key, ".", "-")}-vpce"
  })
}

data "aws_vpc_endpoint_service" "s3" {
  service      = "s3"
  service_type = "Gateway"
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  vpc_endpoint_type = "Gateway"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-s3-vpce"
  })
}
