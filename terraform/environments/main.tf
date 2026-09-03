// Dev environment main.tf placeholder
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "../../modules/vpc"
}
