mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }

  mock_resource "aws_security_group" {
    defaults = {
      id = "sg-12345678"
    }
  }

  mock_resource "aws_iam_role" {
    defaults = {
      id  = "role-runtime"
      arn = "arn:aws:iam::123456789012:role/role-runtime"
    }
  }

  mock_resource "aws_lambda_function" {
    defaults = {
      arn           = "arn:aws:lambda:us-east-1:123456789012:function:ttl-reaper"
      function_name = "ttl-reaper"
    }
  }
}

run "validates_default_runtime_plan" {
  command = plan

  variables {
    name_prefix             = "texinfo-dev"
    vpc_id                  = "vpc-12345678"
    private_subnet_ids      = ["subnet-11111111", "subnet-22222222"]
    private_route_table_ids = ["rtb-11111111"]
    ttl_hours               = 12
  }

  assert {
    condition     = output.security_group_id != ""
    error_message = "Expected security_group_id output to be populated."
  }

  assert {
    condition     = output.reaper_arn != ""
    error_message = "Expected reaper_arn output to be populated."
  }
}
