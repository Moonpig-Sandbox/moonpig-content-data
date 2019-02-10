resource "aws_iam_role" "scaling-role" {
  name = "${var.ContentStackUpdatesTableName}-autoscale-${var.environment}-${data.aws_region.current.name}"

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
    "mnpg:environment" = "${var.environment}"
    "mnpg:name"        = "${var.TagNameValue}"
    "mnpg:owner"       = "${var.TagOwnerValue}"
    "mnpg:team"        = "${var.TagTeamValue}"
    "mnpg:workstream"  = "${var.TagWorkstreamValue}"
  }
}

resource "aws_iam_role_policy" "scaling-role-policy" {
  name        = "${var.ContentStackUpdatesTableName}-autoscale-${var.environment}-${data.aws_region.current.name}"
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
