#!/bin/bash

echo "Please enter an bucket name: "
read var1
echo "Please enter your google project id: "
read var2
cd ..
export GPC_BUCKET_NAME=$var1
export GPC_PROJECT_ID=$var2
echo $var1
echo $var2
export TF_VAR_bucket_name=${GPC_BUCKET_NAME}
export TF_VAR_project_id=${GPC_PROJECT_ID}
terraform init
terraform apply

