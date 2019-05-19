#!/usr/bin/env bash

cd terraform/infra
terraform destroy
rm plan.out
