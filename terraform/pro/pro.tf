terraform {
    required_version = ">= 1.0.0"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region                      = "us-east-1"
    access_key                  = "fake"
    secret_key                  = "fake"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    endpoints {
        dynamodb        = var.localstack_endpoint
        kms             = var.localstack_endpoint
        resourcegroups  = var.localstack_endpoint
        s3              = var.localstack_endpoint
    }
}

variable "env" {
    type = string
    description = "Environment name [pre, pro]"
}

variable "project" {
    type = string
    description = "Project name"
}

module "fake-aws-pro-dynamodb" {
    source  = "../modules/dynamodb"
    project = "${var.project}"
    env     = "${var.env}"
}
