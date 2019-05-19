module "ecr" {
  source = "github.com/jetbrains-infra/terraform-aws-ecr"
  name   = "${var.project_name}_ecr"
}
