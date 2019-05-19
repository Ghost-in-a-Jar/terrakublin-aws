#!/usr/bin/env bash

printf '\n\nStarting the Terraforming!\n\n'
cd infra

terraform init

terraform plan -out=plan.out

terraform apply plan.out

terraform output -json | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]"