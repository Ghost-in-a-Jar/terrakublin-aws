# NOTE: This is the environment definition that will be used by all environments.
# The actual environments (like dev) just inject their environment dependent values to env-def which defines the actual environment and creates that environment using given values.

# NOTE:
# You need the EKS cluster name to be known already when creating VPC
# because it is needed in tags, and EKS glues things together using the tags.
locals {
  eks_cluster_name = "${var.namespace}-${var.env}-ekscluster"
}

# EKS ECR Repo
module "ecr" {
  source    = "../ecr"
  namespace = "${var.namespace}"
  env       = "${var.env}"
  region    = "${var.region}"
}

# EKS with security groups, roles etc.
module "eks" {
  source    = "../eks"
  namespace = "${var.namespace}"
  env       = "${var.env}"
  region    = "${var.region}"
}
