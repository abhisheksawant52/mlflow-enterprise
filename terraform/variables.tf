variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "project" {
  description = "Project name used for tagging and resource naming."
  type        = string
  default     = "mlflow-enterprise"
}

variable "eks_cluster_name" {
  description = "Name of the existing EKS cluster that hosts the MLflow tracking server."
  type        = string
}

variable "mlflow_namespace" {
  description = "Kubernetes namespace to create for the MLflow tracking server."
  type        = string
  default     = "mlflow"
}

# --- Artifact store (S3) ---------------------------------------------------

variable "artifact_bucket_name" {
  description = "Globally unique S3 bucket name for the MLflow artifact store."
  type        = string
}

variable "artifact_force_destroy" {
  description = "Allow Terraform to destroy the artifact bucket even if it is not empty."
  type        = bool
  default     = false
}

# --- Backend store (RDS Postgres) -----------------------------------------

variable "db_name" {
  description = "Name of the MLflow backend database."
  type        = string
  default     = "mlflow"
}

variable "db_username" {
  description = "Master username for the RDS Postgres instance."
  type        = string
  default     = "mlflow"
}

variable "db_instance_class" {
  description = "RDS instance class for the backend store."
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "Allocated storage (GiB) for the RDS instance."
  type        = number
  default     = 20
}

variable "db_multi_az" {
  description = "Whether to deploy the RDS instance across multiple availability zones."
  type        = bool
  default     = false
}

variable "db_subnet_ids" {
  description = "Subnet IDs for the RDS DB subnet group (private subnets recommended)."
  type        = list(string)
}

variable "db_allowed_security_group_ids" {
  description = "Security group IDs allowed to reach the database on port 5432."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID hosting the RDS instance and its security group."
  type        = string
}
