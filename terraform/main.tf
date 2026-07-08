locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# S3 bucket + access policy for the MLflow artifact store.
module "artifact_store" {
  source = "./modules/artifact-store"

  bucket_name   = var.artifact_bucket_name
  force_destroy = var.artifact_force_destroy
  tags          = local.common_tags
}

# RDS Postgres instance used as the MLflow backend (tracking) store.
module "backend_db" {
  source = "./modules/backend-db"

  name_prefix                = local.name_prefix
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.db_subnet_ids
  allowed_security_group_ids = var.db_allowed_security_group_ids
  db_name                    = var.db_name
  username                   = var.db_username
  instance_class             = var.db_instance_class
  allocated_storage          = var.db_allocated_storage
  multi_az                   = var.db_multi_az
  tags                       = local.common_tags
}

# Namespace "hook" into the existing EKS cluster where the Helm chart deploys.
resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = var.mlflow_namespace

    labels = {
      "app.kubernetes.io/part-of" = var.project
      "environment"               = var.environment
    }
  }
}
