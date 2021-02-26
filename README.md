# GCP og Terraform (Task 2)
This project uses terraform to create a google cloud storage *bucket*. This bucket will eventually be used to save terraform state
in task 3 of this exam

Prerequisites:
* Installed Terraform (https://www.terraform.io/downloads.html)
* Installed Gcloud SDK (https://cloud.google.com/sdk/docs/install)

In order to create a Google Cloud bucket you will need a Google Cloud Project & a Google Service account. If you don't have this already, please follow these steps in order before proceeding with creating a bucket
####Creating a google cloud project and google service account
1. Create a Google Cloud Project (https://cloud.google.com/)
2. Click billing & make sure billing is enabled for the project.
3. We're going to open a Service account which terraform can use to create a bucket. Open "Service accounts" in the console (Under IAM & Admin)
4. Fill in the Service account details
5. Grant role "Storage Admin" to the service account. The account should not have more granted roles than necessary for creating a bucket.
6. Open the newly created service account & click the "KEYS" tab. Create a new key by clicking "ADD NEW" and select JSON format. 
7. A json file should have been downloaded which can be used to access the service account. **DO NOT SHARE IT AND DO NOT UPLOAD BY VERSION CONTROL AS IT IS SENSITIVE DATA**

###Creating the bucket
1. You should already have a .json file attached to a service account with sufficient roles to create a bucket. Rename this file to ```terraform_keyfile.json``` And place it inside the ```init````folder of this project. Terraform will use the file for authentication & authorization
2. Terraform can use an identity now, and is ready to create the bucket! We're missing a name for the bucket however. Run the following command to create an environment variable which Terraform will use to name the bucket
For windows:
```
set gcp-bucket-name=[INSERT BUCKET NAME HERE]
```
For linux/mac:
```
export gcp-bucket-name=[INSERT BUCKET NAME HERE]
```
Note: Bucket name is unique & global meaning that you can't have same bucket name as anyone else.
3. Set the project id of the google cloud project as an enviroment variable:
For windows:
```
set gcp-project-id=[INSERT PROJECT ID HERE]
```
For linux/mac:
```
export gcp-project-id=[INSERT PROJECT ID HERE]
```
4. Run command
```terraform init```

5. Run command
```terraform apply```
6. Viola! Terraform has now created a bucket which can be found in the google cloud project.

