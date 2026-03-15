terraform {
  backend "gcs" {
    bucket  = "mktest-terraform-state"
    prefix  = "terraform/state"
  }
}