resource "aws_cloudwatch_event_rule" "sitespeed" {
  name                = "exec-sitespeed"
  schedule_expression = "cron(0 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "sitespeed" {
  rule     = "${aws_cloudwatch_event_rule.sitespeed.name}"
  arn      = "${aws_codebuild_project.sitespeed.arn}"
  role_arn = "${aws_iam_role.invoke-codebuild.arn}"
}

resource "aws_iam_role" "invoke-codebuild" {
  name = "sitespeed-invoke-codebuild"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invoke-codebuild" {
  name = "invoke-codebuild"
  role = "${aws_iam_role.invoke-codebuild.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:StartBuild"
      ],
      "Resource": [
        "${aws_codebuild_project.sitespeed.arn}"
      ]
    }
  ]
}
EOF
}
