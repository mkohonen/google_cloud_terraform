terraform {
  backend "gcs" {
    bucket  = "mkdev-terraform-state"
    prefix  = "terraform/state"
  }
}