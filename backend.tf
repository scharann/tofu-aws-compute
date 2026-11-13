terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "bucket-722141136946-lab"    # Same S3 bucket
    key            = "compute/terraform.tfstate"  # Different state key
    region         = "ap-southeast-2"
    dynamodb_table = "tofu-lab-locks"             # Same DynamoDB table
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}