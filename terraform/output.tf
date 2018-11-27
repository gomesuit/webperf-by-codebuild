output "S3_BUCKET" {
  value = "${aws_s3_bucket.sitespeed.id}"
}

output "S3_BUCKET_RESULT" {
  value = "${aws_s3_bucket.query-result.id}"
}
