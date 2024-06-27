
resource "aws_kinesisanalyticsv2_application" "flink_app" {
  name                   = "nyc-taxi-flink-application"
  runtime_environment    = "FLINK-1_8"
  service_execution_role = aws_iam_role.example.arn

  application_configuration {
    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = aws_s3_bucket.data_bucket.arn
          file_key   = aws_s3_object.example.key
        }
      }
    
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
        auto_scaling_enabled = true
        configuration_type   = "CUSTOM"
        parallelism          = 1
        parallelism_per_kpu  = 1
      }
    }
  }

  tags = {
    env = "tf"
  }
}