terraform {
  required_version = ">= 0.11.8"
}

provider "aws" {
  region = "${var.region}"
}
