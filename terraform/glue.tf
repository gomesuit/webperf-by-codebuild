resource "aws_glue_crawler" "sitespeed" {
  database_name = "${aws_glue_catalog_database.sitespeed.name}"
  name          = "sitespeed"
  role          = "service-role/${aws_iam_role.crawler.name}"
  schedule      = ""

  configuration = <<EOF
{
  "Version":1.0,
  "CrawlerOutput":{
    "Partitions":{
      "AddOrUpdateBehavior":"InheritFromTable"
    },
    "Tables":{
      "AddOrUpdateBehavior":"MergeNewColumns"
    }
  }
}
EOF

  s3_target {
    path = "s3://${aws_s3_bucket.sitespeed.bucket}/json/"

    exclusions = []
  }
}

resource "aws_glue_catalog_database" "sitespeed" {
  name = "sitespeed"
}

resource "aws_iam_role" "crawler" {
  name = "sitespeed-crawler"
  path = "/service-role/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "glue-service" {
  role       = "${aws_iam_role.crawler.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "crawler" {
  name = "crawler"
  role = "${aws_iam_role.crawler.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "s3:GetObject",
          "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.sitespeed.arn}/*"
      ]
    }
  ]
}
EOF
}
