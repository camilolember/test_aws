# In this file put all the logic to crete the proper infraestructure
terraform {
    required_providers {
      # Add the provideres according to the challenges
      aws = {
          source  = "hashicorp/aws"
          version = "~> 6.0"
      }
    }

    backend "s3" {
      bucket = "clemus-demo-bucket"
      key    = "devel.tfstate"
      region = "us-east-1"
    }
}

provider "aws" {
  region = "us-east-1"
}

module "react_app_devel" {
  source = "../../modules/"
}

# Add the resources relatedo to the provider