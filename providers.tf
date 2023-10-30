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

module "ecs" {
  source      = "./modules/ecs"
  environment = var.environment
  region      = var.region
}