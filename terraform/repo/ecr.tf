module "ecr" {
  source = "github.com/jetbrains-infra/terraform-aws-ecr"
  name   = "${var.project_name}_${var.env}_ecr"
  region = "us-east-1"
}
