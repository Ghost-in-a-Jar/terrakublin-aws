# Dev environment.
# NOTE: If environment copied, change environment related values (e.g. "develop" -> "prod").

##### Terraform configuration #####

# Usage:
# AWS_PROFILE=tmv-test terraform init (only first time)
# AWS_PROFILE=tmv-test terraform get
# AWS_PROFILE=tmv-test terraform plan
# AWS_PROFILE=tmv-test terraform apply

# NOTE: You have to create backend S3 bucket manually before creating new env!
terraform {
  required_version = ">=0.11.10"

  backend "s3" {
    bucket = "terrakubelin-stage-terraform-backend"
    key    = "terrakubelin-stage-terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

# Here we inject our values to the environment definition module which creates all actual resources.
module "env-def" {
  source    = "../../modules/env-def"
  namespace = "terrakublin"
  env       = "staging"
  region    = "us-east-1"
}
