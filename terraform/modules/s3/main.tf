variable "project" {
    type = string
}

variable "env" {
    type = string
}

resource "aws_s3_bucket" "this" {
    bucket = "${var.project}-${var.env}-s3"

    tags = {
        project = "${var.project}"
        env     = "${var.env}"
    }
}

resource "aws_s3_bucket_ownership_controls" "this" {
    bucket = aws_s3_bucket.this.id

    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "this" {
    bucket = aws_s3_bucket.this.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_object" "this" {
    bucket = aws_s3_bucket.this.id
    key    = "lambda.zip"
    source = "${path.module}/lambda.zip"
    etag   = filemd5("${path.module}/lambda.zip")

    tags = {
        project = "${var.project}"
        env     = "${var.env}"
    }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "object_key" {
  value = aws_s3_object.this.key
}

output "object_etag" {
  value = aws_s3_object.this.etag
}
