terraform {
  backend "s3" {
    bucket       = "CHANGE-ME-terraform-state-bucket"
    key          = "texinfo/lmlmxtend-runtime/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
