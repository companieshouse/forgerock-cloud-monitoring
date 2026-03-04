terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }

    archive = {
      source = "hashicorp/archive"
      version = "2.7.1"
    }
  }
}

provider "aws" {
  region = var.region
}
