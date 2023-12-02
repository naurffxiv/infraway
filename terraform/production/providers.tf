# Specify required provider as maintained by civo
terraform {
  required_providers {
    civo = {
      source = "civo/civo"
    }
  }
  backend "s3" {
    endpoint                    = "https://objectstore.nyc1.civo.com/"
    bucket                      = "raidingway"
    key                         = "terraform/production.tfstate"
    region                      = "NYC1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

# Configure the Civo Provider
provider "civo" {
  token = var.civo_token
  region = "NYC1"
}
