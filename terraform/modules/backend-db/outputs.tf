output "endpoint" {
  description = "Connection endpoint (host:port) of the RDS instance."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Hostname of the RDS instance."
  value       = aws_db_instance.this.address
}

output "db_name" {
  description = "Name of the created database."
  value       = aws_db_instance.this.db_name
}

output "security_group_id" {
  description = "Security group protecting the database."
  value       = aws_security_group.db.id
}

output "master_password" {
  description = "Generated master password for the database."
  value       = random_password.master.result
  sensitive   = true
}
