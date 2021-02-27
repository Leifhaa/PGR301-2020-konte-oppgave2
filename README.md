# GCP and Terraform ![Build Status](https://travis-ci.com/Leifhaa/PGR301-2020-konte-oppgave2.svg?branch=master)
- This is repository 2/2 of exam in lecture pgr301 (Continuation exam).
- Repository 1/2 can be found [here](https://github.com/Leifhaa/konte)
- The exam text can be found [here](https://github.com/Leifhaa/konte/docs)

The repository contains 3 independent guides. Guide 1 is necessary to complete before doing guide 2 and so on.




Prerequisites before running any of the guides:
* Installed Terraform (https://www.terraform.io/downloads.html)
* Installed Gcloud SDK (https://cloud.google.com/sdk/docs/install)

In order to create a Google Cloud bucket you will need a Google Cloud Project & a Google Service account. If you don't have this already, please follow these steps in order before proceeding with creating a bucket
# Guide 1. Creating a Google Cloud Project and google service account
If you already have a Google Cloud Project and Google Service account, you can skip this guide. Make sure you have a Key file as explained in step 4 however.
## 1. Create a google project
Create a Google Cloud Project (https://cloud.google.com/)
### 2. Enable billing
Click billing & make sure billing is enabled for the project.
## 3. Create service account
We're going to open a Service account which terraform can use to create a bucket. 
- Open "Service accounts" in the console (Under IAM & Admin).
- Click "Create service account"
- Fill in account details. Skip adding roles now, as we will handle these later
## 4. Add Key file to service account
- Open the newly created service account & click the "KEYS" tab. Create a new key by clicking "ADD NEW" and select JSON format. 
A json file should have been downloaded which can be used to access the service account. :warning: **DO NOT SHARE IT AND DO NOT UPLOAD BY VERSION CONTROL AS IT IS SENSITIVE DATA** :warning:


# Guide 2. Creating the bucket
Before following this guide, it's important that you've already completed these steps:
- Created a Google Cloud project and service account. If not, follow [these steps](#Creating-a-google-cloud-project-and-google-service-account) before beginning.


## 1. Add roles to the service account
In order to complete this guide, add the following roles to the service account:
| Role name | Description | Reason |
| --- | --- | --- |
| Storage Admin | Grants full controll of GCS sources | Service account needs to be allowed to create a bucket

## 2. Set keyfile
You should already have a .json file attached to a service account with sufficient roles to create a bucket. Rename this file to `terraform_keyfile.json` And place it in the root folder of this project. Terraform will use the file for authentication & authorization
## 3. Set bucket name
Great, terraform has an identity, and is ready to create the bucket! We're missing a name for the bucket however. Run the following command to create an environment variable which Terraform will use to name the bucket
For windows:
```
set gcp-bucket-name=[INSERT BUCKET NAME HERE]
```
For linux/mac:
```
export gcp-bucket-name=[INSERT BUCKET NAME HERE]
```
Note: Bucket name is unique & global meaning that you can't have same bucket name as anyone else.
## 4. Set project id
Set the project id of the google cloud project as an environment variable:
For windows:
```
set gcp-project-id=[INSERT PROJECT ID HERE]
```
For linux/mac:
```
export gcp-project-id=[INSERT PROJECT ID HERE]
```
## 5 Export terraform variables
Export the environment variables to terraform
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

## 6 Run terraform
Run the following commands:
```sh
terraform init
terraform apply
```
## 7. Viola! Terraform has now created a bucket which can be found in the google cloud project.
>Tip: Step 3-7 could also be done by opening the init/scripts folder and running the deploy script according to your operating system.
TODO: TEST LINUX SCRIPT

# Guide 3. Provisioning GCP resources with Terraform
Before following this guide, it's important that you've already completed these steps:
- Created a Google Cloud project and service account. If not, follow [these steps](#Creating-a-google-cloud-project-and-google-service-account) before beginning.
- Created a Google cloud bucket. If not, follow [these steps](#Creating-the-bucket) before beginning. We will use Google Cloud Storage to store a state file from Terraform.
- Compute Engine API needs to be enabled


In this guide we will provision Google Cloud Platform services by using terraform. Let's get started!
## 1. Setting up the roles
Your service account will need sufficient roles in order to create the infrastructure. Visit the IAM page in Google Cloud Platform and add the following roles to your service account

| Role name | Description | Reason |
| --- | --- | --- |
| Storage Admin | Grants full controll of GCS sources | Needs access to bucket for managing the state file |
| Compute Admin | Full control of compute resources | Needs access to create, delete and manage compute instances  |
| Create Service Accounts | Access to create service accounts | Terraform needs to create a service account for compute instance (recommended by google) |
| Service Account User | Run operation as the service account | Needed for attaching created service account to compute instance (recommended by google) |
> Notice: We're only adding required roles to the service account. This reduces damage in case the service account is stolen.
## 2. Set terraform backend storage
Open the ```backend.tf``` file in the root directory and change the bucket name to the bucket name which you previously created.
```diff
terraform {
  #Save the terraform state (backend) to google cloud storage (gcs)
  backend "gcs" {
!   bucket = "hello-world"  <------- Replace hello-world with your bucket name
    #Prefix inside the bucket. Will create a workspace with such name
    prefix = "terraformstate"
    credentials = "terraform_keyfile.json"
  }
}
```
## 3. Open .travis.yml located the root folder. Change the Global environment variable "GCP_PROJECT_ID" to your project id
```diff
env:
  global:
!     - GCP_PROJECT_ID=helloworld       <------  Change helloworld to your google cloud project id
```
## 4. Encrypt service account key file
Considering we want travis to run terraform for building the infrastructure, it needs to authenticate itself. We will encrypt the json key file attached to the service account upload this encrypted file to travis so it can authenticate.
- Make sure the json key file is located in the root directory of this project. It has to be named `terraform_keyfile.json`
- Make sure terminal is in the root directory of this project and run the following:
```sh
travis encrypt-file terraform_keyfile.json --pro
```
 Console will output a file starting with `openssl aes-256-cbc ...`. 
 - Copy this line to clipboard. 
 - Edit .travis.yml and go to the "before_install" step. You will find a similar line as you just copied.
 - Replace this with the one you copied in the clipboard. The changes would look like this:
```diff
before_install:
  #Travis will decrypt our key file and use it
-  - openssl aes-256-cbc -K $encrypted_61dc43fb09f9_key -iv $encrypted_61dc43fb09f9_iv -in terraform_keyfile.json.enc -out terraform_keyfile.json -d
+  - openssl aes-256-cbc -K $encrypted_18ehq8qu39r8_key -iv $encrypted_18ehq8qu39f8_iv -in terraform_keyfile.json.enc -out terraform_keyfile.json -d
...
```


## 5. Commit the changes
:warning: **The terraform.keyfile.json file should not be committed to repository or shared** :warning:
Commit the updated .travis.yml and the encrypted key file to github
```shell script
git add terraform_keyfile.json.enc .travis.yml
```

```shell script 
git commit -m "Updated service account"
```

```shell script
git push -u origin master
```

## 6. Set travis environment variable
Run command 
```shell script
travis env set TF_ENV_machine_type f1-micro --public
```
This will set an environment in travis which we will use to specify which type of compute instance we want.


- Todo: Complete Init script deploy-linux



