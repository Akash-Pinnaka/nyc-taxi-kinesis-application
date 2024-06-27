# Define the provider
provider "aws" {
    region = "us-east-1"
}

# Create an AWS S3 bucket
resource "aws_s3_bucket" "data_bucket" {
    bucket = "nyc-taxi-tf-akash-7"
    force_destroy = true

    tags = {
        Name = "nyc-taxi-tf-akash-7"
        env = "tf"
    }
}

resource "aws_s3_object" "fill_data_bucket" {
  bucket = aws_s3_bucket.data_bucket.id

  key = "yellow_tripdata_2024-01.parquet"

  source = "./yellow_tripdata_2024-01.parquet"
}

