terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "mensal4"

  default_tags {
    tags = {
      Project     = "Mensal4-TodoApp"
      Environment = "Academic"
      ManagedBy   = "Terraform"
    }
  }
}
