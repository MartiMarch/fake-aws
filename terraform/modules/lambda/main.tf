variable "project" {
    type = string
}

variable "env" {
    type = string
}

variable "bucket_name" {
    type = string
}

variable "object_key" {
    type = string
}

variable "object_etag" {
    type = string
}

variable "table_stream_arn" {
    type = string
}

variable "email_secret_arn" {
    type = string
    sensitive = true
}

resource "aws_iam_role" "this" {
    name = "${var.project}-${var.env}-lambda-role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
        Statement = [
            {
                Action    = "sts:AssumeRole"
                Effect    = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        project = "${var.project}"
        env     = "${var.env}"
    }
}

resource "aws_iam_role_policy_attachment" "this" {
    role       = aws_iam_role.this.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "this" {
    name = "${var.project}-${var.env}-lambda-dynamodb-policy"
    role = aws_iam_role.this.id

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "dynamodb:DescribeStream",
                "dynamodb:GetRecords",
                "dynamodb:GetShardIterator",
                "dynamodb:ListStreams",
            ]
            Resource = var.table_stream_arn
        },
        {
            Effect = "Allow"
            Action = [
                "secretsmanager:GetSecretValue"
            ]
            Resource = var.email_secret_arn
        }
    ]
    })
}

resource "aws_lambda_function" "this" {
    s3_bucket        = var.bucket_name
    s3_key           = var.object_key
    function_name    = "${var.project}-${var.env}-lambda-function"
    role             = aws_iam_role.this.arn
    handler          = "lambda.handler"
    source_code_hash = base64sha256(var.object_etag)
    runtime          = "python3.11"
    timeout          = 60
    memory_size      = 512
    tags = {
        project = "${var.project}"
        env     = "${var.env}"
    }
}

resource "aws_lambda_event_source_mapping" "this" {
    event_source_arn = var.table_stream_arn
    function_name    = aws_lambda_function.this.arn
    starting_position = "LATEST"
    enabled = true
}
