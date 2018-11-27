#!/bin/bash -x

DOMAIN=$1
DEVICE=$2
CATEGORY=$3
OUTPUT_DATE=$4

YEAR=$(echo $OUTPUT_DATE | awk -F/ '{print $1}')
MONTH=$(echo $OUTPUT_DATE | awk -F/ '{print $2}')
DAY=$(echo $OUTPUT_DATE | awk -F/ '{print $3}')
HOUR=$(echo $OUTPUT_DATE | awk -F/ '{print $4}')
MINUTE=$(echo $OUTPUT_DATE | awk -F/ '{print $5}')

SQL="""
ALTER TABLE
  sitespeed.json
ADD IF NOT EXISTS PARTITION (
  domain = '$DOMAIN',
  device = '$DEVICE',
  category = '$CATEGORY',
  year = '$YEAR',
  month = '$MONTH',
  day = '$DAY',
  hour = '$HOUR',
  minutes = '$MINUTE'
)
LOCATION
  's3://$S3_BUCKET/json/$DOMAIN/$DEVICE/$CATEGORY/$OUTPUT_DATE';
"""

echo "$SQL"

output_location="s3://$S3_BUCKET_RESULT/"

aws athena start-query-execution \
  --result-configuration "OutputLocation=$output_location" \
  --query-string "$SQL"
