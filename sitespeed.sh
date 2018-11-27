#!/bin/bash

if [ $# -ne 3 ]; then
  echo "usage : $0 <domain> <url> <category>"
  exit 1
fi

DOMAIN=$1
TARGET_URL=$2
CATEGORY=$3

echo "DOMAIN: $DOMAIN"
echo "URL: $TARGET_URL"
echo "CATEGORY: $CATEGORY"

/bin/bash -x /start.sh "$TARGET_URL" \
  -b chrome \
  --s3.path "raw/$DOMAIN/desktop/$CATEGORY/$OUTPUT_DATE" \
  --s3.bucketname "$S3_BUCKET" \
  --outputFolder "sitespeed-result/$DOMAIN/desktop/$CATEGORY/$OUTPUT_DATE" \
  --config config.json

/bin/bash -x /start.sh "$TARGET_URL" \
  -b chrome \
  --s3.path "raw/$DOMAIN/mobile/$CATEGORY/$OUTPUT_DATE" \
  --s3.bucketname "$S3_BUCKET" \
  --outputFolder "sitespeed-result/$DOMAIN/mobile/$CATEGORY/$OUTPUT_DATE" \
  --config config.json \
  --mobile

aws s3 cp \
  "sitespeed-result/$DOMAIN/desktop/$CATEGORY/$OUTPUT_DATE/data/browsertime.summary-total.json" \
  "s3://$S3_BUCKET/json/$DOMAIN/desktop/$CATEGORY/$OUTPUT_DATE/"

./create_partition.sh "$DOMAIN" 'desktop' "$CATEGORY" "$OUTPUT_DATE"

aws s3 cp \
  "sitespeed-result/$DOMAIN/mobile/$CATEGORY/$OUTPUT_DATE/data/browsertime.summary-total.json" \
  "s3://$S3_BUCKET/json/$DOMAIN/mobile/$CATEGORY/$OUTPUT_DATE/"

./create_partition.sh "$DOMAIN" 'mobile' "$CATEGORY" "$OUTPUT_DATE"
