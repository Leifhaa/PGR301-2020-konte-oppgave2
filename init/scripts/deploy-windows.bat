SET /P bucketname= Please enter an bucket name:
SET /P projectid= Please enter your google project id:

cd ..
set TF_VAR_bucket_name="%gcp-bucket-name%"
set TF_VAR_project_id="%gcp-project-id%"
terraform init
terraform apply