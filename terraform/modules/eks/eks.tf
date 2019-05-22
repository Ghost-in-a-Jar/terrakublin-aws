provider "aws" {
  region = "us-east-1"
}

locals {
  # The usage of the specific kubernetes.io/cluster/* resource tags below are required
  # for EKS and Kubernetes to discover and manage networking resources
  # https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html#base-vpc-networking
  eks_cluster_name = "${var.namespace}-${var.env}-ekscluster"

  cluster_path = "kubernetes.io/cluster/${local.eks_cluster_name}"
  tags         = "${merge(var.tags, map(local.cluster_path, "shared"))}"
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${var.namespace}"
  stage      = "${var.env}"
  name       = "vpc"
  tags       = "${var.tags}"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  name                = "subnets"
  namespace           = "${var.namespace}"
  stage               = "${var.env}"
  tags                = "${var.tags}"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"
  region              = "${var.region}"
}

module "eks_cluster" {
  source     = "git::https://github.com/cloudposse/terraform-aws-eks-cluster.git?ref=master"
  name       = "${local.eks_cluster_name}"
  namespace  = "${var.namespace}"
  stage      = "${var.env}"
  tags       = "${local.tags}"
  vpc_id     = "${module.vpc.vpc_id}"
  subnet_ids = ["${module.subnets.public_subnet_ids}"]

  # `workers_security_group_count` is needed to prevent `count can't be computed` errors
  workers_security_group_ids   = ["${module.eks_workers.security_group_id}"]
  workers_security_group_count = 1
}

module "eks_workers" {
  source                             = "git::https://github.com/cloudposse/terraform-aws-eks-workers.git?ref=master"
  name                               = "workers"
  namespace                          = "${var.namespace}"
  stage                              = "${var.env}"
  tags       = "${local.tags}"
  vpc_id                             = "${module.vpc.vpc_id}"
  subnet_ids                         = ["${module.subnets.public_subnet_ids}"]
  health_check_type                  = "EC2"
  instance_type                      = "t3a.nano"
  min_size                           = 1
  max_size                           = 3
  wait_for_capacity_timeout          = "10m"
  cluster_name                       = "${local.eks_cluster_name}"
  cluster_endpoint                   = "${module.eks_cluster.eks_cluster_endpoint}"
  cluster_certificate_authority_data = "${module.eks_cluster.eks_cluster_certificate_authority_data}"
  cluster_security_group_id          = "${module.eks_cluster.security_group_id}"

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "80"
  cpu_utilization_low_threshold_percent  = "20"
}

