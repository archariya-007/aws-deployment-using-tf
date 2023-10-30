terraform {
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
  backend "s3" {
    # bucket         = "hulk-health-communication-tf-state"
    # key            = "tf-infra/terraform.tfstate"
    # region         = "us-east-1"
    # dynamodb_table = "terraform-state-locking"
    # encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project = "health communication"
      owner   = "connect squad"
      appid   = "Health_CommunicationProcessor"
    }
  }
}

# module "tf-state" {
#   source      = "./modules/s3"
#   environment = var.environment
#   region      = var.region
#   bucket_name = var.tf_state_lockedtbl
# }

module "ecs" {
  source      = "./modules/ecs"
  environment = var.environment
  region      = var.region
}