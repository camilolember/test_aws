terraform {
  backend "s3"{
    bucket = "clemus-demo-bucket"
    key    = "devel/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region     = "us-east-1"
}

module "deploy_infra" {
  source      = "../../modules/app/"
  env          = "devel"
}