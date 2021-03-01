terraform {
  #Save the terraform state (backend) to google cloud storage (gcs)
  backend "gcs" {
    bucket = "leifhaa-my-terraform-bucket-windows-bat"
    #Prefix inside the bucket. Will create a workspace with such name
    prefix = "terraformstate"
    credentials = "terraform_keyfile.json"
  }
}