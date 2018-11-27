resource "random_id" "webperf-s3" {
  byte_length = 6
}

resource "aws_s3_bucket" "query-result" {
  bucket = "webperf-by-codebuild-query-result-${random_id.webperf-s3.hex}"
}

resource "aws_s3_bucket" "sitespeed" {
  bucket = "webperf-by-codebuild-${random_id.webperf-s3.hex}"

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "sitespeed" {
  bucket = "${aws_s3_bucket.sitespeed.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.sitespeed.arn}/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "${var.my_ip}"
          ]
        }
      }
    }
  ]
}
POLICY
}
