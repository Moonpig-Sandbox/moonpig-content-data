resource "aws_dynamodb_global_table" "dynamodb-table" {
  name = "${var.ContentStackUpdatesTableName}-${var.environment}"

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "eu-west-1"
  }

  replica {
    region_name = "ap-southeast-2"
  }
}
