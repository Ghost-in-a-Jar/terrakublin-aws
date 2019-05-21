output "eks_security_group_name" {
  value = "${module.eks_cluster.security_group_name}"
}

output "eks_security_group_id" {
  value = "${module.eks_cluster.security_group_id}"
}

output "eks_cluster_id" {
  value = "${module.eks_cluster.eks_cluster_id}"
}

output "eks_cluster_endpoint" {
  value = "${module.eks_cluster.eks_cluster_endpoint}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnet_ids" {
  value = "${module.subnets.public_subnet_ids}"
}

output "private_subnet_ids" {
  value = "${module.subnets.private_subnet_ids}"
}
