# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region  = var.region
  profile = "adm-tosin.ojo"

  default_tags {
    tags = {
      "Automation"      = "terraform"
      "Project"         = var.project_name
      "Environment"     = var.environment
      "CostCenter"      = var.costcenter
      "CreatedBy"       = var.createdby
      "DataSensitivity" = var.data_sensitivity
    }
  }
}