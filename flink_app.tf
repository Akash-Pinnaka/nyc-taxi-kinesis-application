
resource "aws_kinesisanalyticsv2_application" "flink_app" {
  name                   = "nyc-taxi-flink-application"
  runtime_environment    = "FLINK-1_18"
  service_execution_role = aws_iam_role.nyc-kinesis-analytics-role.arn

  application_configuration {
    application_code_configuration {
      # code_content {
      #   s3_content_location {
      #     bucket_arn = aws_s3_bucket.data_bucket.arn
      #     file_key   = aws_s3_object.example.key
      #   }
      # }
    
      code_content_type = "ZIPFILE"
    }

    flink_application_configuration {
      checkpoint_configuration {
        configuration_type = "DEFAULT"
      }

      monitoring_configuration {
        configuration_type = "CUSTOM"
        log_level          = "DEBUG"
        metrics_level      = "TASK"
        
      }
      parallelism_configuration {
        auto_scaling_enabled = false
        configuration_type   = "CUSTOM"
        parallelism          = 1
        parallelism_per_kpu  = 1
      }
    }
  }
  cloudwatch_logging_options {
    log_stream_arn = aws_cloudwatch_log_stream.log_stream.arn
  }

  tags = {
    env = "tf"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/kinesis-analytics/nyc-taxi-flink-application"
  retention_in_days = 1

  tags = {
    env = "tf"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name = "kinesis-analytics-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}