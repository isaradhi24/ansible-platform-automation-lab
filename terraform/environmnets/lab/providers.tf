terraform {
  required_version = ">=1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project     = "ansible-platform-automation-lab"
      Environment = "lab"
      ManageBy    = "Terraform"
      Temporary   = "true"

    }
  }

}