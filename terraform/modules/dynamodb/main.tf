variable "project" {
    type = string
}

variable "env" {
    type = string
}

resource "aws_kms_key" "this" {
    description              = "Clave SSE para el DynamoDB de pre"
    key_usage                = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    enable_key_rotation      = true

    tags = {
        project = "${var.project}"
        env     = "${var.env}"
    }
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.project}-${var.env}-dynamodb-see"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_dynamodb_table" "this" {
    name           = "${var.project}-${var.env}-dynamodb"
    billing_mode   = "PROVISIONED"
    read_capacity  = 10
    write_capacity = 5
    hash_key       = "productId"

    attribute {
        name = "productId"
        type = "S"
    }
    attribute {
        name = "company"
        type = "S"
    }
    attribute {
        name = "provider"
        type = "S"
    }

    global_secondary_index {
        name            = "IndexCompany"
        hash_key        = "company"
        projection_type = "ALL"
        read_capacity   = 10
        write_capacity  = 5
    }

    global_secondary_index {
        name            = "IndexProveder"
        hash_key        = "provider"
        projection_type = "ALL"
        read_capacity   = 10
        write_capacity  = 5
    }

    stream_enabled   = true
    stream_view_type = "NEW_AND_OLD_IMAGES"
    server_side_encryption {
        enabled     = true
        kms_key_arn = "arn:aws:kms:us-east-1:000000000000:alias/${var.project}-${var.env}-dynamodb-sse"
    }

    tags = {
        project = "${var.project}"
        env = "${var.env}"
    }
}

output "table_stream_arn" {
    value = aws_dynamodb_table.this.stream_arn
}
