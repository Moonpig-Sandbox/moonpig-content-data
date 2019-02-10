resource "aws_dynamodb_table" "dynamodb-table" {
  hash_key         = "id"
  name             = "${var.ContentStackUpdatesTableName}-${var.environment}"
  read_capacity    = "${var.ContentStackUpdatesTableReadCapacityUnitsMin}"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  write_capacity   = "${var.ContentStackUpdatesTableWriteCapacityUnitsMin}"

  attribute {
    name = "id"
    type = "S"
  }

  tags {
    "mnpg:environment" = "${var.environment}"
    "mnpg:name"        = "${var.TagNameValue}"
    "mnpg:owner"       = "${var.TagOwnerValue}"
    "mnpg:team"        = "${var.TagTeamValue}"
    "mnpg:workstream"  = "${var.TagWorkstreamValue}"
  }
}
