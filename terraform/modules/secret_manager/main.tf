variable "project" {
  type = string
}

variable "env" {
  type = string
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


resource "aws_secretsmanager_secret" "this" {
  name = "${var.project}-${var.env}-email-secret"

  tags = {
    project = "${var.project}"
    env     = "${var.env}"
  }
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    sender_email        = var.sender_email
    sender_email_secret = var.sender_email_secret
    reciever_email      = var.receiver_email
  })
}

output "email_secret_arn" {
    value = aws_secretsmanager_secret.this.arn
}
