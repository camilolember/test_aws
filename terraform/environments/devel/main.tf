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
  access_key = ${ secrets.AWS_ACCESS_KEY }
  secret_key = ${ secrets.AWS_SECRET_ACCESS_KEY }
}

module "deploy_infra" {
  source      = "../../modules/app/"
}