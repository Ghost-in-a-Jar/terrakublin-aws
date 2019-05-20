variable "tags" {
  type    = "map"
  default = {}
}

locals {
  namespace = "${var.project_name}"
  stage     = "${var.env}"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${local.namespace}"
  stage      = "${local.stage}"
  name       = "vpc"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=master"

  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]

  namespace           = "${local.namespace}"
  stage               = "${local.stage}"
  name                = "subnets"
  region              = "us-east-1"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"
}

module "cluster" {
  source    = "git::https://github.com/cloudposse/terraform-aws-eks-cluster.git?ref=master"
  namespace = "${local.namespace}"
  stage     = "${local.stage}"
  name      = "-cluster"
  tags      = "${var.tags}"
  vpc_id    = "${module.vpc.vpc_id}"

  subnet_ids = [
    "${module.subnets.public_subnet_ids}",
  ]

  endpoint_private_access = "true"
  endpoint_public_access  = "false"

  # `workers_security_group_count` is needed to prevent `count can't be computed` errors
  workers_security_group_ids = [
    "${module.workers.security_group_id}",
  ]

  workers_security_group_count = 1
}

module "workers" {
  source        = "git::https://github.com/cloudposse/terraform-aws-eks-workers.git?ref=master"
  namespace     = "${local.namespace}"
  stage         = "${local.stage}"
  name          = "workers"
  tags          = "${var.tags}"
  instance_type = "t3a.nano"
  vpc_id        = "${module.vpc.vpc_id}"

  subnet_ids = [
    "${module.subnets.public_subnet_ids}",
  ]

  health_check_type                  = "EC2"
  min_size                           = 1
  max_size                           = 3
  wait_for_capacity_timeout          = "10m"
  associate_public_ip_address        = true
  cluster_name                       = "${var.project_name}_cluster"
  cluster_endpoint                   = "${module.cluster.eks_cluster_endpoint}"
  cluster_certificate_authority_data = "${module.cluster.eks_cluster_certificate_authority_data}"
  cluster_security_group_id          = "${module.cluster.security_group_id}"

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "80"
  cpu_utilization_low_threshold_percent  = "20"
}

module "alb" {
  source    = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.2.0"
  namespace = "${local.namespace}"
  stage     = "${local.stage}"
  name      = "-alb"

  ip_address_type = "ipv4"
  vpc_id          = "${module.vpc.vpc_id}"

  subnet_ids = [
    "${module.subnets.public_subnet_ids}",
  ]

  access_logs_region = "us-east-1"
}

//module "production_www" {
//  source          = "git::https://github.com/cloudposse/terraform-aws-route53-alias.git?ref=master"
//  aliases         = ["www.terrakublin.dev"]
//  parent_zone_name  = "us-east-1a"
//  target_dns_name = "${module.alb.dns_name}"
//  target_zone_id  = "${module.alb.zone_id}"
//}

