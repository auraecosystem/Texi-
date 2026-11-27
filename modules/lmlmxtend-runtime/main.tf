resource "aws_security_group" "runtime" {
  name_prefix = "${var.name_prefix}-rt-"
  description = "Security group for ${var.name_prefix} runtime workloads"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-runtime-sg"
  })
}

data "aws_iam_policy_document" "runtime_assume" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs-tasks.amazonaws.com",
        "lambda.amazonaws.com",
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "runtime" {
  name               = "${var.name_prefix}-runtime-role"
  assume_role_policy = data.aws_iam_policy_document.runtime_assume.json
  tags               = var.tags
}
