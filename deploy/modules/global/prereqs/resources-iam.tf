resource "aws_iam_role" "pipeline-role" {
  name = "${var.PipelineRoleName}-${var.EnvironmentName}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::${var.SdlcAwsAccountId}:user/${var.RootPipelineUsername}"
          ]
        },
        "Action": "sts:AssumeRole"
    }
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

resource "aws_iam_role_policy" "pipeline-role-policy" {
  name = "${var.PipelineRoleName}-${var.EnvironmentName}"
  role = "${aws_iam_role.pipeline-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "application-autoscaling:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:dynamodb:eu-west-1:${data.aws_caller_identity.current.account_id}:table/${var.StateTableName}",
        "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.ContentStackUpdatesTableName}-${var.EnvironmentName}",
        "arn:aws:dynamodb::${data.aws_caller_identity.current.account_id}:global-table/${var.ContentStackUpdatesTableName}-${var.EnvironmentName}"
      ]
    },
    {
      "Action": [
        "iam:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.ContentStackUpdatesTableName}-autoscale-${var.EnvironmentName}-*"
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.StateBucketName}",
        "arn:aws:s3:::${var.StateBucketName}/*"
      ]
    }
  ]
}
EOF
}
