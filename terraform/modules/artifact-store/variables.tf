variable "bucket_name" {
  description = "Globally unique name of the S3 artifact bucket."
  type        = string
}

variable "force_destroy" {
  description = "Allow the bucket to be destroyed even when it contains objects."
  type        = bool
  default     = false
}

variable "noncurrent_version_expiration_days" {
  description = "Days after which non-current object versions are expired."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags applied to all resources in this module."
  type        = map(string)
  default     = {}
}
