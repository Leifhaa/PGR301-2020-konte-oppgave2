SET /P gcp-bucket-name= Please enter an bucket name:
SET /P gcp-project-id= Please enter your google project id:

cd ..
set TF_VAR_bucket_name=%gcp-bucket-name%
set TF_VAR_project_id=%gcp-project-id%
terraform init
terraform apply