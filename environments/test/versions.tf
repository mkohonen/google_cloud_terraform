terraform {
  required_version = ">= 1.5.0" # Lukitsee Terraformin version

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Sallii vain pienet päivitykset (vakaus)
    }
  }
}