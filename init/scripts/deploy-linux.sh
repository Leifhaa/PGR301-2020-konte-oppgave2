#!/bin/bash

echo "Please enter an bucket name: "
read var1
echo "Please enter your google project id: "
read var2
cd ..
export gcp_bucket_name=$var1
export gcp_project_id=$var2
echo $var1
echo $var2
export TF_VAR_bucket_name=${gcp_bucket_name}
export TF_VAR_project_id=${gcp_project_id}
terraform init
terraform apply

