#!/usr/bin/env bash

printf '\n\nStarting the Terraforming!\n\n'
cd infra
ENV="develop"
terraform init
terraform plan -out=plan.out
terraform apply plan.out
