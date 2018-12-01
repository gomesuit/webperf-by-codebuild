resource "aws_glue_catalog_database" "webperf-by-codebuild" {
  name = "webperf_by_codebuild_${random_id.webperf.hex}"
}

resource "aws_glue_catalog_table" "json" {
  database_name = "${aws_glue_catalog_database.webperf-by-codebuild.name}"
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
      type = "struct<connectstart:struct<median:int,mean:int,min:int,p90:int,max:int>,domcomplete:struct<median:int,mean:int,min:int,p90:int,max:int>,domcontentloadedeventend:struct<median:int,mean:int,min:int,p90:int,max:int>,domcontentloadedeventstart:struct<median:int,mean:int,min:int,p90:int,max:int>,dominteractive:struct<median:int,mean:int,min:int,p90:int,max:int>,domainlookupend:struct<median:int,mean:int,min:int,p90:int,max:int>,domainlookupstart:struct<median:int,mean:int,min:int,p90:int,max:int>,duration:struct<median:int,mean:int,min:int,p90:int,max:int>,fetchstart:struct<median:int,mean:int,min:int,p90:int,max:int>,loadeventend:struct<median:int,mean:int,min:int,p90:int,max:int>,loadeventstart:struct<median:int,mean:int,min:int,p90:int,max:int>,redirectend:struct<median:int,mean:int,min:int,p90:int,max:int>,redirectstart:struct<median:int,mean:int,min:int,p90:int,max:int>,requeststart:struct<median:int,mean:int,min:int,p90:int,max:int>,responseend:struct<median:int,mean:int,min:int,p90:int,max:int>,responsestart:struct<median:int,mean:int,min:int,p90:int,max:int>,secureconnectionstart:struct<median:int,mean:int,min:int,p90:int,max:int>,starttime:struct<median:int,mean:int,min:int,p90:int,max:int>,unloadeventend:struct<median:int,mean:int,min:int,p90:int,max:int>,unloadeventstart:struct<median:int,mean:int,min:int,p90:int,max:int>,workerstart:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    columns {
      name = "pagetimings"
      type = "struct<backendtime:struct<median:int,mean:int,min:int,p90:int,max:int>,domcontentloadedtime:struct<median:int,mean:int,min:int,p90:int,max:int>,dominteractivetime:struct<median:int,mean:int,min:int,p90:int,max:int>,domainlookuptime:struct<median:int,mean:int,min:int,p90:int,max:int>,frontendtime:struct<median:int,mean:int,min:int,p90:int,max:int>,pagedownloadtime:struct<median:int,mean:int,min:int,p90:int,max:int>,pageloadtime:struct<median:int,mean:int,min:int,p90:int,max:int>,redirectiontime:struct<median:int,mean:int,min:int,p90:int,max:int>,serverconnectiontime:struct<median:int,mean:int,min:int,p90:int,max:int>,serverresponsetime:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    columns {
      name = "visualmetrics"
      type = "struct<speedindex:struct<median:int,mean:int,min:int,p90:int,max:int>,perceptualspeedindex:struct<median:int,mean:int,min:int,p90:int,max:int>,firstvisualchange:struct<median:int,mean:int,min:int,p90:int,max:int>,lastvisualchange:struct<median:int,mean:int,min:int,p90:int,max:int>,visualreadiness:struct<median:int,mean:int,min:int,p90:int,max:int>,visualcomplete85:struct<median:int,mean:int,min:int,p90:int,max:int>,visualcomplete95:struct<median:int,mean:int,min:int,p90:int,max:int>,visualcomplete99:struct<median:int,mean:int,min:int,p90:int,max:int>>"
    }

    input_format      = "org.apache.hadoop.mapred.TextInputFormat"
    location          = "s3://${aws_s3_bucket.webperf-by-codebuild.bucket}/json/"
    output_format     = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    number_of_buckets = "-1"

    ser_de_info {
      parameters {
        paths = "firstPaint,fullyLoaded,navigationTiming,pageTimings,rumSpeedIndex,visualMetrics"
      }

      name                  = "OrcSerDe"
      serialization_library = "org.openx.data.jsonserde.JsonSerDe"
    }

    parameters {
      classification = "json"
    }
  }
}
