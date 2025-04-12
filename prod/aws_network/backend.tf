terraform {
  backend "s3" {
    bucket = "acs730-final-nh"
    key    = "prod/network/terraform.tfstate"
    region = "us-east-1"
  }
}
