variable "name_prefix" {
  description = "Prefix used to name database resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID hosting the database security group."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to Postgres on port 5432."
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "Name of the database created on the instance."
  type        = string
  default     = "mlflow"
}

variable "username" {
  description = "Master username."
  type        = string
  default     = "mlflow"
}

variable "engine_version" {
  description = "Postgres engine version."
  type        = string
  default     = "16.3"
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Deploy across multiple availability zones."
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
