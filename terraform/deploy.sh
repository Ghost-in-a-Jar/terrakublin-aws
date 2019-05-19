#!/usr/bin/env bash

printf '\n\nStarting the Terraforming!\n\n'
pushd infra
ENV="develop"
terraform init
terraform plan -out=plan.out
terraform apply plan.out
terraform output -json > terraform.out
popd