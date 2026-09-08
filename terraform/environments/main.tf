terraform {
  required_version = ">= 1.6.0"

  backend "s3" {}

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

# Public Subnets
module "public_subnet_a" {
  source = "../modules/subnet"

  name              = "hi-${var.environment}-public-subnet-a"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

module "public_subnet_b" {
  source = "../modules/subnet"

  name              = "hi-${var.environment}-public-subnet-b"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
}

# Private Subnets
module "private_subnet_a" {
  source = "../modules/subnet"

  name              = "hi-${var.environment}-private-subnet-a"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
}

module "private_subnet_b" {
  source = "../modules/subnet"

  name              = "hi-${var.environment}-private-subnet-b"
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
}

module "route_table" {
  source = "../modules/route-table"

  name        = "hi-${var.environment}"
  environment = var.environment

  vpc_id = module.vpc.vpc_id

  internet_gateway_id = module.vpc.internet_gateway_id

  public_subnet_a_id  = module.public_subnet_a.subnet_id
  public_subnet_b_id  = module.public_subnet_b.subnet_id
  private_subnet_a_id = module.private_subnet_a.subnet_id
  private_subnet_b_id = module.private_subnet_b.subnet_id
}