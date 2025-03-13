terraform {
  cloud {
    organization = "maythazin-jp"
    ## Required for Terraform Enterprise; Defaults to app.terraform.io for HCP Terraform
    hostname = "app.terraform.io"

    workspaces {
      name = "terraform-blue-green"
    }
  }
}


#remote cli driven workflow, announce key in variable in remote
#AWS_ACCESS_KEY_ID
#AWS_SECRET_ACCESS_KEY
#AWS_DEFAULT_REGION