provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# Reads the target EKS cluster so the MLflow namespace can be provisioned as a
# "hook" into an existing cluster. The cluster itself is managed elsewhere.
data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}
