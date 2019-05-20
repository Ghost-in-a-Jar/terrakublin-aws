output "REGION" {
  description = "AWS region."
  value       = "${var.region}"
}

output "ENV" {
  value = "${var.env}"
}

output "IMAGE_NAME" {
  value = "${module.ecr.ecr_host}/${module.ecr.ecr_repo}"
}
