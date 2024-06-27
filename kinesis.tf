resource "aws_kinesis_stream" "data_stream" {
  name = "nyc-taxi-tf"

  shard_count = 1

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    env = "tf"
  }
}

