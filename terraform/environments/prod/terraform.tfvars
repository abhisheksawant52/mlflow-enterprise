aws_region       = "us-east-1"
environment      = "prod"
project          = "mlflow-enterprise"
eks_cluster_name = "platform-eks-prod"
mlflow_namespace = "mlflow"

artifact_bucket_name   = "mlflow-enterprise-artifacts-prod"
artifact_force_destroy = false

db_name              = "mlflow"
db_username          = "mlflow"
db_instance_class    = "db.r6g.large"
db_allocated_storage = 100
db_multi_az          = true

vpc_id                        = "vpc-0prod000000000000"
db_subnet_ids                 = ["subnet-0prodaaa11111", "subnet-0prodbbb22222", "subnet-0prodccc33333"]
db_allowed_security_group_ids = ["sg-0prodekseks111"]
