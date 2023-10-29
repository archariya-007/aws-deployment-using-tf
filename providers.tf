terraform {

  backend "s3" {
    bucket         = "hulk-health-communication-tf-state"
    key            = "tf-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "tf-state" {
  source      = "./modules/s3"
  environment = var.environment
  bucket_name = var.tf_state_lockedtbl
}