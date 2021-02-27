#!/bin/bash
set -ex
export TF_VAR_project_id=$GCP_PROJECT_ID
export TF_VAR_machine_type=$TF_ENV_machine_type
terraform init
terraform plan
terraform apply --auto-approve
terraform output