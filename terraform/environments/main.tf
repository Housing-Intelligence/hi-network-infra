terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../modules/vpc"

  name        = "hi-${var.environment}-vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "subnet_a" {
  source = "../modules/subnet"

  name              = "hi-${var.environment}-subnet-a"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

module "subnet_b" {
  source = "../modules/subnet"

  name              = "hi-${var.environment}-subnet-b"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
}