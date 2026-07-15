terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.54"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Remote state backend. Configure per environment with:
  #   terraform init -backend-config=environments/<env>/backend.hcl
  # backend "s3" {
  #   bucket         = "mlflow-enterprise-tfstate"
  #   key            = "mlflow-enterprise/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "mlflow-enterprise-tflock"
  #   encrypt        = true
  # }
}
