output "bucket_name" {
  description = "Name of the artifact store bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the artifact store bucket."
  value       = aws_s3_bucket.this.arn
}

output "access_policy_arn" {
  description = "ARN of the IAM policy granting access to the bucket."
  value       = aws_iam_policy.access.arn
}
