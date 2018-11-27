resource "aws_codebuild_project" "sitespeed" {
  name          = "sitespeed"
  service_role  = "${aws_iam_role.sitespeed.arn}"
  badge_enabled = "true"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "sitespeedio/sitespeed.io:7.3.6"
    type            = "LINUX_CONTAINER"
    privileged_mode = "true"
  }

  source {
    type                = "GITHUB"
    location            = "${var.git_repository}"
    git_clone_depth     = 0
    report_build_status = "false"
    insecure_ssl        = "false"

    auth {
      type = "OAUTH"
    }

    buildspec = "buildspec.yml"
  }
}

resource "aws_cloudwatch_log_group" "codebuild" {
  name = "/aws/codebuild/${aws_codebuild_project.sitespeed.name}"
}

resource "aws_iam_role" "sitespeed" {
  name = "codebuild-sitespeed-service-role"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_log" {
  name = "cloudwatch_log"
  role = "${aws_iam_role.sitespeed.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "${aws_cloudwatch_log_group.codebuild.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "sitespeed-s3" {
  name = "sitespeed-s3"
  role = "${aws_iam_role.sitespeed.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.sitespeed.arn}",
        "${aws_s3_bucket.sitespeed.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "athena" {
  name = "athena"
  role = "${aws_iam_role.sitespeed.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.query-result.arn}/sitespeed/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "athena:StartQueryExecution",
        "athena:GetQueryExecution",
        "glue:GetDatabase",
        "glue:GetTable",
        "glue:BatchCreatePartition"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
