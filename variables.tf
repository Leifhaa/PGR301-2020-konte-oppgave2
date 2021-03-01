variable "project_id" {
  description = "Project id of the google cloud project"
  type = string
}

variable "machine_type" {
  description = "Specifies type of machine in google compute"
  type = string
}

variable "foo_variable" {
  description = "Variable is made to make a git push to ensure travis only builds infrastructure on master branch.!"
  type = string
}
