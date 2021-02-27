#!/bin/bash
set -ex
#project id is set in travis file
export TF_VAR_project_id=$GCP_PROJECT_ID
#machine type is set on travis by command 'travis set env ...'
export TF_VAR_machine_type=$TF_ENV_machine_type
terraform init
terraform plan
terraform apply --auto-approve
terraform output