resource "aws_glue_catalog_database" "sitespeed" {
  name = "sitespeed"
}

resource "aws_glue_catalog_table" "json" {
  database_name = "sitespeed"
  name          = "json"
  table_type    = "EXTERNAL_TABLE"

  partition_keys {
    name = "domain"
    type = "string"
  }

  partition_keys {
    name = "device"
    type = "string"
  }

  partition_keys {
    name = "category"
    type = "string"
  }

  partition_keys {
    name = "year"
    type = "string"
  }

  partition_keys {
    name = "month"
    type = "string"
  }

  partition_keys {
    name = "day"
    type = "string"
  }

  partition_keys {
    name = "hour"
    type = "string"
  }

  partition_keys {
    name = "minute"
    type = "string"
  }

  parameters {
    classification = "json"
  }

  storage_descriptor {
    columns {
      name = "firstpaint"
      type = "struct<median:int,mean:int,min:int,p90:int,max:int>"
    }

    columns {
      name = "fullyloaded"
      type = "struct<median:int,mean:int,min:int,p90:int,max:int>"
    }

    columns {
      name = "rumspeedindex"
      type = "struct<median:int,mean:int,min:int,p90:int,max:int>"
    }

    columns {
      name = "navigationtiming"
      type = "struct<connectStart:struct<median:int,mean:int,min:int,p90:int,max:int>,domComplete:struct<median:int,mean:int,min:int,p90:int,max:int>,domContentLoadedEventEnd:struct<median:int,mean:int,min:int,p90:int,max:int>,domContentLoadedEventStart:struct<median:int,mean:int,min:int,p90:int,max:int>,domInteractive:struct<median:int,mean:int,min:int,p90:int,max:int>,domainLookupEnd:struct<median:int,mean:int,min:int,p90:int,max:int>,domainLookupStart:struct<median:int,mean:int,min:int,p90:int,max:int>,duration:struct<median:int,mean:int,min:int,p90:int,max:int>,fetchStart:struct<median:int,mean:int,min:int,p90:int,max:int>,loadEventEnd:struct<median:int,mean:int,min:int,p90:int,max:int>,loadEventStart:struct<median:int,mean:int,min:int,p90:int,max:int>,redirectEnd:struct<median:int,mean:int,min:int,p90:int,max:int>,redirectStart:struct<median:int,mean:int,min:int,p90:int,max:int>,requestStart:struct<median:int,mean:int,min:int,p90:int,max:int>,responseEnd:struct<median:int,mean:int,min:int,p90:int,max:int>,responseStart:struct<median:int,mean:int,min:int,p90:int,max:int>,secureConnectionStart:struct<median:int,mean:int,min:int,p90:int,max:int>,startTime:struct<median:int,mean:int,min:int,p90:int,max:int>,unloadEventEnd:struct<median:int,mean:int,min:int,p90:int,max:int>,unloadEventStart:struct<median:int,mean:int,min:int,p90:int,max:int>,workerStart:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    columns {
      name = "pagetimings"
      type = "struct<backEndTime:struct<median:int,mean:int,min:int,p90:int,max:int>,domContentLoadedTime:struct<median:int,mean:int,min:int,p90:int,max:int>,domInteractiveTime:struct<median:int,mean:int,min:int,p90:int,max:int>,domainLookupTime:struct<median:int,mean:int,min:int,p90:int,max:int>,frontEndTime:struct<median:int,mean:int,min:int,p90:int,max:int>,pageDownloadTime:struct<median:int,mean:int,min:int,p90:int,max:int>,pageLoadTime:struct<median:int,mean:int,min:int,p90:int,max:int>,redirectionTime:struct<median:int,mean:int,min:int,p90:int,max:int>,serverConnectionTime:struct<median:int,mean:int,min:int,p90:int,max:int>,serverResponseTime:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    columns {
      name = "painttiming"
      type = "struct<first-contentful-paint:struct<median:int,mean:int,min:int,p90:int,max:int>,first-paint:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    columns {
      name = "visualmetrics"
      type = "struct<SpeedIndex:struct<median:int,mean:int,min:int,p90:int,max:int>,PerceptualSpeedIndex:struct<median:int,mean:int,min:int,p90:int,max:int>,FirstVisualChange:struct<median:int,mean:int,min:int,p90:int,max:int>,LastVisualChange:struct<median:int,mean:int,min:int,p90:int,max:int>,VisualReadiness:struct<median:int,mean:int,min:int,p90:int,max:int>,VisualComplete85:struct<median:int,mean:int,min:int,p90:int,max:int>,VisualComplete95:struct<median:int,mean:int,min:int,p90:int,max:int>,VisualComplete99:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    input_format      = "org.apache.hadoop.mapred.TextInputFormat"
    location          = "s3://${aws_s3_bucket.sitespeed.bucket}/json/"
    output_format     = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    number_of_buckets = "-1"

    ser_de_info {
      parameters {
        paths = "firstPaint,fullyLoaded,navigationTiming,pageTimings,paintTiming,rumSpeedIndex,visualMetrics"
      }

      name                  = "OrcSerDe"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    parameters {
      classification = "json"
    }
  }
}
