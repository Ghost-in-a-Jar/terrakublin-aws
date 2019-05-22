# NOTE: This is the environment definition that will be used by all environments.
# The actual environments (like dev) just inject their environment dependent values to env-def which defines the actual environment and creates that environment using given values.

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
