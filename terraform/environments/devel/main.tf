terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region     = "us-east_1"
}

module "deploy_infra" {
  source      = "../../modules/app/"
}