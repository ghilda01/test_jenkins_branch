terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }

  backend "s3" {
    bucket = "somfyprotect-infra-states"
    key    = "dgh/terraform.tfstate"
    region = "eu-west-1"
    #dynamodb_table = "terraform-locks-dev"
  }
}

provider "aws" {
  region = var.aws_region
}
