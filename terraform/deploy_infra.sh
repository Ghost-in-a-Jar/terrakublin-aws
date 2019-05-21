#!/usr/bin/env bash

export AWS_PROFILE=personal
export ENV=staging

printf '\n\nStarting the Terraforming!\n\n'
pushd envs/$ENV
terraform init
terraform plan -out=plan.out
terraform apply plan.out
terraform output -json > terraform.out
popd
