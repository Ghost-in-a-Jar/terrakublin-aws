#!/usr/bin/env bash

printf '\n\nStarting the Terraforming!\n\n'
cd infra
ENV="develop"
terraform plan -out=plan.out
terraform apply plan.out
