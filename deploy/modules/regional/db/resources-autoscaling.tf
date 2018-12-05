resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = "${var.ContentStackUpdatesTableReadCapacityUnitsMax}"
  min_capacity       = "${var.ContentStackUpdatesTableReadCapacityUnitsMin}"
  resource_id        = "table/${var.ContentStackUpdatesTableName}-${var.EnvironmentName}"
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
  resource_id        = "table/${var.ContentStackUpdatesTableName}-${var.EnvironmentName}"
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
