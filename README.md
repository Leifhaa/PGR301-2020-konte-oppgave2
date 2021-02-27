# GCP og Terraform (Task 2)
This project uses terraform to create a google cloud storage *bucket*. This bucket will eventually be used to save terraform state
in task 3 of this exam

Prerequisites:
* Installed Terraform (https://www.terraform.io/downloads.html)
* Installed Gcloud SDK (https://cloud.google.com/sdk/docs/install)

In order to create a Google Cloud bucket you will need a Google Cloud Project & a Google Service account. If you don't have this already, please follow these steps in order before proceeding with creating a bucket
(### Creating-a-google-cloud-project-and-google-service account)
1. Create a Google Cloud Project (https://cloud.google.com/)
2. Click billing & make sure billing is enabled for the project.
3. We're going to open a Service account which terraform can use to create a bucket. Open "Service accounts" in the console (Under IAM & Admin)
4. Fill in the Service account details
5. Skip granting of roles for now. These will be added later
6. Open the newly created service account & click the "KEYS" tab. Create a new key by clicking "ADD NEW" and select JSON format. 
7. A json file should have been downloaded which can be used to access the service account. **DO NOT SHARE IT AND DO NOT UPLOAD BY VERSION CONTROL AS IT IS SENSITIVE DATA**

### Creating the bucket
Before following this guide, make sure tou have already created a Google cloud project and service account.

[Insert required priveledges here]

1. You should already have a .json file attached to a service account with sufficient roles to create a bucket. Rename this file to ```terraform_keyfile.json``` And place it in the root folder of this project. Terraform will use the file for authentication & authorization
2. Great, terraform has an identity, and is ready to create the bucket! We're missing a name for the bucket however. Run the following command to create an environment variable which Terraform will use to name the bucket
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
4. Export the environment variables to terraform
For windows:
```
set TF_VAR_bucket_name=%gcp-bucket-name%
set TF_VAR_project_id=%gcp-project-id%
```
For linux/mac:
```
export TF_VAR_bucket_name=$gpc-bucket-name
export TF_VAR_project_id=$gpc-project-id
```

5. Run command
```terraform init```

6. Run command
```terraform apply```
7. Viola! Terraform has now created a bucket which can be found in the google cloud project.

Todo: Følg den samme flyten som de har gjort på google tutorialene?


### Provisioning GCP resources with Terraform
Before following this guide, it's important that you've already completed these steps:
- Created a Google Cloud project and service account. If not, follow [these steps](#Creating a google cloud project and google service account) first
- Created a google cloud bucket. If not, please refer to the description above [Insert link] for how to create one. We will use Google Cloud Storage to store a state file from Terraform.

It's also important that your service account minimum has these roles:
[Insert table here]

Before we start, the terraform service account will need more permissions. Add the following roles to our terraform service account:
- Compute Admin = For administrating of compute instances

- Identity and Access Management (IAM) API needs to be enabled (?)
- Compute Engine API needs to be enabled


In this guide we will provision Google Cloud Platform services by using terraform. Let's get started!
1. Open the ```backend.tf``` file in the root directory and change the bucket name to the bucket name which you previously created.
```
terraform {
  #Save the terraform state (backend) to google cloud storage (gcs)
  backend "gcs" {
    bucket = "hello-world"  <------------------------   Replace hello-world with your bucket name
    #Prefix inside the bucket. Will create a workspace with such name
    prefix = "terraformstate"
    credentials = "terraform_keyfile.json"
  }
}
```
2. Open .travis.yml in the root folder. Change the Global enviroment variable "GCP_PROJECT_ID" to your project id
```env:
     global:
       - GCP_PROJECT_ID=helloworld       <-------------- Change helloworld to your google cloud project id
```
3. 


