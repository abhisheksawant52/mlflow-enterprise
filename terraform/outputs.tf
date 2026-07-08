output "artifact_bucket_name" {
  description = "Name of the S3 artifact store bucket."
  value       = module.artifact_store.bucket_name
}

output "artifact_bucket_arn" {
  description = "ARN of the S3 artifact store bucket."
  value       = module.artifact_store.bucket_arn
}

output "artifact_uri" {
  description = "S3 URI to configure as the MLflow default artifact root."
  value       = "s3://${module.artifact_store.bucket_name}/"
}

output "db_endpoint" {
  description = "Connection endpoint (host:port) of the RDS backend store."
  value       = module.backend_db.endpoint
}

output "db_name" {
  description = "Name of the MLflow backend database."
  value       = module.backend_db.db_name
}

output "backend_store_uri_template" {
  description = "Template MLflow backend store URI (inject the password at deploy time)."
  value       = "postgresql://${var.db_username}:REPLACE_ME@${module.backend_db.endpoint}/${module.backend_db.db_name}"
  sensitive   = true
}

output "mlflow_namespace" {
  description = "Kubernetes namespace created for the MLflow tracking server."
  value       = kubernetes_namespace.mlflow.metadata[0].name
}
