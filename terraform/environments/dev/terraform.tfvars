aws_region       = "us-east-1"
environment      = "dev"
project          = "mlflow-enterprise"
eks_cluster_name = "platform-eks-dev"
mlflow_namespace = "mlflow"

artifact_bucket_name   = "mlflow-enterprise-artifacts-dev"
artifact_force_destroy = true

db_name              = "mlflow"
db_username          = "mlflow"
db_instance_class    = "db.t3.medium"
db_allocated_storage = 20
db_multi_az          = false

vpc_id                        = "vpc-0dev0000000000000"
db_subnet_ids                 = ["subnet-0devaaa11111", "subnet-0devbbb22222"]
db_allowed_security_group_ids = ["sg-0devekseks111"]
