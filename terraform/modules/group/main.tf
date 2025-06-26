variable "project" {
    type = string
}

variable "env" {
    type = string
}

resource "aws_resourcegroups_group" "this" {
  name         = "${var.project}-${var.env}"
  description  = "Grupo de recursos para ${var.project} en el entorno ${var.env}"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [
        {
          Key = "project"
          Values = [var.project]
        },
        {
          Key = "env"
          Values = [var.env]
        }
      ]
    })
    type = "TAG_FILTERS_1_0"
  }

  tags = {
    project = var.project
    env     = var.env
  }
}