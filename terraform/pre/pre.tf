variable "env" {
    type = string
    description = "Environment name [pre, pro]"
}

variable "project" {
    type = string
    description = "Project name"
}

variable "localstack_endpoint" {
    type = string
    description = "LocalStack endpoint"
}


variable "sender_email" {
  type      = string
  sensitive = true
}

variable "sender_email_secret" {
  type      = string
  sensitive = true
}

variable "receiver_email" {
  type      = string
  sensitive = true
}


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
        lambda          = var.localstack_endpoint
        iam             = var.localstack_endpoint
        secretsmanager  = var.localstack_endpoint
    }
}

module "fake-aws-pre-group" {
    source  = "../modules/group"
    project = "${var.project}"
    env     = "${var.env}"
}

module "fake-aws-pre-dynamodb" {
    source  = "../modules/dynamodb"
    project = "${var.project}"
    env     = "${var.env}"
    depends_on = [module.fake-aws-pre-group]
}

module "fake-aws-pre-s3" {
    source  = "../modules/s3"
    project = "${var.project}"
    env     = "${var.env}"
    depends_on = [module.fake-aws-pre-dynamodb]
}

module "fake-aws-pre-secrets" {
    source              = "../modules/secret_manager"
    project             = "${var.project}"
    env                 = "${var.env}"
    sender_email        = var.sender_email
    sender_email_secret = var.sender_email_secret
    receiver_email      = var.receiver_email
}


module "fake-aws-pre-lambda" {
    source           = "../modules/lambda"
    project          = var.project
    env              = var.env
    bucket_name      = module.fake-aws-pre-s3.bucket_name
    object_key       = module.fake-aws-pre-s3.object_key
    object_etag      = module.fake-aws-pre-s3.object_etag
    table_stream_arn = module.fake-aws-pre-dynamodb.table_stream_arn
    email_secret_arn = module.fake-aws-pre-secrets.email_secret_arn

    depends_on = [
        module.fake-aws-pre-dynamodb,
        module.fake-aws-pre-s3,
        module.fake-aws-pre-secrets
    ]
}
