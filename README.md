# GCP and Terraform ![Build Status](https://travis-ci.com/Leifhaa/PGR301-2020-konte-oppgave2.svg?branch=master)

## Introduction
This is repository 2/2 of [exam in lecture pgr301 (Continuation exam)](https://github.com/Leifhaa/PGR301-2020-konte-oppgave2/tree/master/docs). Repository 1/2 can be found [here](https://github.com/Leifhaa/konte).
This repository contains 3 guides for managing [Google Cloud Platform](#https://cloud.google.com/). Guide 1 is necessary to complete before doing guide 2 and so on. 
* Guide 2 answers task 2 of the exam. 
* Guide 3 answers task 3 of the exam.  

## Prerequisites before running the guides:
* Installed Terraform (https://www.terraform.io/downloads.html)
* Installed Gcloud SDK (https://cloud.google.com/sdk/docs/install)
### Table of contents
<!--
  ⚠️ DO NOT UPDATE THE TABLE OF CONTENTS MANUALLY ️️⚠️
  run `npx markdown-toc -i README.md`
-->

<!-- toc -->

- [Guide 1. Creating a Google Cloud Project and google service account](#guide-1-creating-a-google-cloud-project-and-google-service-account)
  * [1. Create a google project](#1-create-a-google-project)
  * [2. Enable billing](#2-enable-billing)
  * [3. Create service account](#3-create-service-account)
  * [4. Add Key file to service account](#4-add-key-file-to-service-account)
- [Guide 2. Creating a Google Storage Bucket with terraform](#guide-2-creating-a-google-storage-bucket-with-terraform)
  * [1. Add roles to the service account](#1-add-roles-to-the-service-account)
  * [2. Set keyfile](#2-set-keyfile)
  * [3. Set bucket name](#3-set-bucket-name)
  * [4. Set project id](#4-set-project-id)
  * [5 Export terraform variables](#5-export-terraform-variables)
  * [6 Run terraform](#6-run-terraform)
  * [7. :rainbow: Viola! Terraform has now created a bucket which can be found in the google cloud project.](#7-rainbow-viola-terraform-has-now-created-a-bucket-which-can-be-found-in-the-google-cloud-project)
- [Guide 3. Provisioning GCP resources with Terraform](#guide-3-provisioning-gcp-resources-with-terraform)
  * [1. Setting up the roles](#1-setting-up-the-roles)
  * [2. Set terraform backend storage](#2-set-terraform-backend-storage)
  * [3. Edit project id in travis](#3-edit-project-id-in-travis)
  * [4. Set travis environment variable](#4-set-travis-environment-variable)
  * [5. Encrypt service account key file](#5-encrypt-service-account-key-file)
  * [6. Commit the changes](#6-commit-the-changes)
  * [7. Trigger a build!](#7-trigger-a-build)
  * [8. Destroy the project (Optional)](#8-destroy-the-project-optional)

<!-- tocstop -->

# Guide 1. Creating a Google Cloud Project and google service account
![](./docs/google-platform-identity.png) <br>
If you already have a Google Cloud Project and Google Service account, you can skip this guide. Make sure you have a Key file as explained in step 4.
## 1. Create a google project
Create a Google Cloud Project (https://cloud.google.com/)
## 2. Enable billing
Click billing & make sure billing is enabled for the project.
## 3. Create service account
We're going to open a Service account which terraform can use to create a bucket. 
- Open "Service accounts" in the console (Under IAM & Admin).
- Click "Create service account"
- Fill in account details. Add role Storage Admin to the service account.
## 4. Add Key file to service account
- Open the newly created service account & click the "KEYS" tab. Create a new key by clicking "ADD NEW" and select JSON format. 
A json file should have been downloaded which can be used to access the service account.<br> :warning: **DO NOT SHARE IT AND DO NOT UPLOAD BY VERSION CONTROL AS IT IS SENSITIVE DATA** :warning:

<br />
<br />
<br />

# Guide 2. Creating a Google Storage Bucket with terraform
![](./docs/travis-terraform.png) <br>

:information_source: Before following this guide, it's important that you've already completed these steps:
- Created a Google Cloud project and service account. If not, follow [these steps](#Guide-1-Creating-a-Google-Cloud-Project-and-google-service-account) before beginning.


## 1. Add roles to the service account
In order to complete this guide, add the following roles to the service account if you have not already:
| Role name | Description | Reason |
| --- | --- | --- |
| Storage Admin | Grants full controll of GCS sources | Service account needs to be allowed to create a bucket

## 2. Set keyfile
You should already have a key .json file attached to a service account with sufficient roles to create a bucket. Rename this file to `terraform_keyfile.json` And place it in the `root directory` of this project. Terraform will use the file for authentication & authorization. :warning: **The terraform_keyfile.json file should not be committed to repository or shared** :warning:

## 3. Set bucket name
Great, terraform has an identity, and is ready to create the bucket! We're missing a name for the bucket however. Run the following command to create an environment variable which Terraform will use to name the bucket
<br>
For windows users, run command:
```
set gcp_bucket_name=[INSERT BUCKET NAME HERE]
```
For linux/mac users, run command:
```
export gcp_bucket_name=[INSERT BUCKET NAME HERE]
```
>Note: Bucket name is unique & global meaning that you can't have same bucket name as anyone else.
## 4. Set project id
Set the project id of the google cloud project as an environment variable:
<br>
For windows users, run command:
```
set gcp_project_id=[INSERT PROJECT ID HERE]
```
For linux/mac users, run command:
```
export gcp_project_id=[INSERT PROJECT ID HERE]
```
## 5 Export terraform variables
Export the environment variables to terraform
<br>
For windows users, run command:
```
set TF_VAR_bucket_name=%gcp_bucket_name%
set TF_VAR_project_id=%gcp_project_id%
```
For linux/mac users, run command:
```
export TF_VAR_bucket_name=$gpc_bucket_name
export TF_VAR_project_id=$gpc_project_id
```

## 6 Run terraform
Make sure terminal is open in `/init` directory. <br />
Run the following commands:
```sh
terraform init
terraform apply
```
## 7. :rainbow: Viola! Terraform has now created a bucket which can be found in the google cloud project.
>Tip: Step 3-7 could also be done by opening the init/scripts folder and running the deploy script according to your operating system.

<br />
<br />
<br />

# Guide 3. Provisioning GCP resources with Terraform
![](./docs/terraform-travis-compute.png) <br>
:information_source: Before following this guide, it's important that you've already completed these steps:
- Created a Google Cloud project and service account. If not, follow [these steps](#Guide-1-Creating-a-Google-Cloud-Project-and-google-service-account) before beginning.
- Created a Google cloud bucket. If not, follow [these steps](#Guide-2-Creating-the-bucket) before beginning. We will use Google Cloud Storage to store a state file from Terraform.
- Compute Engine API needs to be enabled in Google Cloud Console.
- Identity and Access Management (IAM) API needs to be enabled in Google Cloud Console.


In this guide we will provision Google Cloud Platform services by using terraform. Let's get started!
## 1. Setting up the roles
Your service account will need sufficient roles in order to create the infrastructure. Visit the IAM page in Google Cloud Platform and add the following roles to your service account

| Role name | Description | Reason |
| --- | --- | --- |
| Storage Admin | Grants full controll of GCS sources | Needs access to bucket for managing the state file |
| Compute Admin | Full control of compute resources | Needs access to create, delete and manage compute instances  |
| Create Service Accounts | Access to create service accounts | Terraform needs to create a service account for compute instance (recommended by google) |
| Delete Service Accounts | Access to delete service accounts | Needed if we edit accounts or do destroy infrastructure |
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
Push the change to github

## 3. Edit project id in travis
Open .travis.yml located the root folder. Change the Global environment variable "GCP_PROJECT_ID" to your project id
```diff
env:
  global:
!     - GCP_PROJECT_ID=helloworld       <------  Change helloworld to your google cloud project id
```

## 4. Set travis environment variable
Run command 
```shell script
travis env set TF_ENV_machine_type f1-micro --public
```
This will set an environment in travis which we will use to specify which type of compute instance we want.

## 5. Encrypt service account key file
Considering we want travis to run terraform for building the infrastructure, it needs to authenticate itself. We will encrypt the json key file attached to the service account upload this encrypted file to github so travis collect it and authenticate with it.
- Make sure the json key file is located in the root directory of this project. It has to be named `terraform_keyfile.json`
- Make sure terminal is in the root directory of this project and run the following:
```sh
travis encrypt-file terraform_keyfile.json --pro
```
 Console will output a file starting with `openssl aes-256-cbc ...`. 
 - Copy this line to clipboard. 
 - Edit `.travis.yml` and go to the "before_install" step. You will find a similar line as you just copied.
 - Replace this with the one you copied in the clipboard. The changes would look something like this:
```diff
before_install:
  #Travis will decrypt our key file and use it
-  - openssl aes-256-cbc -K $encrypted_61dc43fb09f9_key -iv $encrypted_61dc43fb09f9_iv -in terraform_keyfile.json.enc -out terraform_keyfile.json -d
+  - openssl aes-256-cbc -K $encrypted_18ehq8qu39r8_key -iv $encrypted_18ehq8qu39f8_iv -in terraform_keyfile.json.enc -out terraform_keyfile.json -d
...
```


## 6. Commit the changes
:warning: **The unencrypted terraform_keyfile.json file should not be committed to repository or shared** :warning:
Commit the updated `.travis.yml` and `terraform_keyfile.json.enc`  file to github. 
>Notice we commit the encrypted file, not the original key file. 

<br> Run command
```shell script
git add terraform_keyfile.json.enc .travis.yml 
```
Run command
```shell script 
git commit -m "Updated service account"
```
Run command
```shell script
git push -u origin master
```



## 7. Trigger a build!
- Trigger a new build travis build by committing and pushing a change to master/main branch. Travis won't build on other branches. 
- Visit [travis](https://travis-ci.com/) and click this repository to view the process of terraform setting up our infrastructure via travis. 
- You can view the Job log and see any if there's any errors, what infrastructure changes are applied etc. 
<br />
 
 Once travis successfully finished running, the infrastructure according to our terraform files should be live on google cloud platform. Congratulations on your new infrastructure! :construction_worker: :construction_worker:

## 8. Destroy the project (Optional)
Running the infrastructure costs money. If your no longer interested in having the infrastructure live & want to save money, open terminal in root directory and run:
```shell script
terraform init
terraform destroy
```
Terraform will ask you to enter var.machine_type. Enter the same machine value as you set in [step 4](#4-Set-travis-environment-variable)

