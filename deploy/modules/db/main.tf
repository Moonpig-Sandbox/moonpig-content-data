provider "aws" {
  alias = "region"
}

data "aws_region" "current" {
  provider = "aws.region"
}

resource "aws_dynamodb_table" "dynamodb-table" {
  hash_key         = "id"
  name             = "${var.ContentStackUpdatesTableName}-${var.EnvironmentName}"
  read_capacity    = "${var.ContentStackUpdatesTableReadCapacityUnitsMin}"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  write_capacity   = "${var.ContentStackUpdatesTableWriteCapacityUnitsMin}"

  attribute {
    name = "id"
    type = "S"
  }

  tags {
    "mnpg:environment" = "${var.TagEnvironmentValue}"
    "mnpg:name"        = "${var.TagNameValue}"
    "mnpg:owner"       = "${var.TagOwnerValue}"
    "mnpg:team"        = "${var.TagTeamValue}"
    "mnpg:workstream"  = "${var.TagWorkstreamValue}"
  }
}

resource "aws_iam_role" "scaling-role" {
  name = "${var.ContentStackUpdatesTableName}-autoscale-${var.EnvironmentName}-${data.aws_region.current.name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags {
    "mnpg:environment" = "${var.TagEnvironmentValue}"
    "mnpg:name"        = "${var.TagNameValue}"
    "mnpg:owner"       = "${var.TagOwnerValue}"
    "mnpg:team"        = "${var.TagTeamValue}"
    "mnpg:workstream"  = "${var.TagWorkstreamValue}"
  }
}

resource "aws_iam_role_policy" "scaling-role-policy" {
  name        = "${var.ContentStackUpdatesTableName}-autoscale-${var.EnvironmentName}-${data.aws_region.current.name}"
  role        = "${aws_iam_role.scaling-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:DescribeTable",
        "dynamodb:UpdateTable",
        "cloudwatch:PutMetricAlarm",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:SetAlarmState",
        "cloudwatch:DeleteAlarms"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = "${var.ContentStackUpdatesTableReadCapacityUnitsMax}"
  min_capacity       = "${var.ContentStackUpdatesTableReadCapacityUnitsMin}"
  resource_id        = "table/${var.ContentStackUpdatesTableName}"
  role_arn           = "${aws_iam_role.scaling-role.arn}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_read_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = "${var.ContentStackUpdatesTableAutoScalePolicyTargetValue}"
  }
}

resource "aws_appautoscaling_target" "dynamodb_table_write_target" {
  max_capacity       = "${var.ContentStackUpdatesTableWriteCapacityUnitsMax}"
  min_capacity       = "${var.ContentStackUpdatesTableWriteCapacityUnitsMin}"
  resource_id        = "table/${var.ContentStackUpdatesTableName}"
  role_arn           = "${aws_iam_role.scaling-role.arn}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  name               = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${aws_appautoscaling_target.dynamodb_table_write_target.resource_id}"
  scalable_dimension = "${aws_appautoscaling_target.dynamodb_table_write_target.scalable_dimension}"
  service_namespace  = "${aws_appautoscaling_target.dynamodb_table_write_target.service_namespace}"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = "${var.ContentStackUpdatesTableAutoScalePolicyTargetValue}"
  }
}
