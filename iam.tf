# Iam role for the Kinesis Analytics application

resource "aws_iam_role" "nyc-kinesis-analytics-role" {
  name = "nyc-kinesis-analytics-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    env = "tf"
  }
}

resource "aws_iam_role_policy" "nyc-kinesis-analytics-role-policy" {
  name = "nyc-kinesis-analytics-role-policy"
  role = aws_iam_role.nyc-kinesis-analytics-role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadCode",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ListCloudwatchLogGroups",
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogGroups"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:992382386350:log-group:*"
        ]
      },
      {
        "Sid" : "ListCloudwatchLogStreams",
        "Effect" : "Allow",
        "Action" : [
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:992382386350:log-group:/aws/kinesis-analytics/nyc-taxi-flink-application:log-stream:*"
        ]
      },
      {
        "Sid" : "PutCloudwatchLogs",
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:us-east-1:992382386350:log-group:/aws/kinesis-analytics/nyc-taxi-flink-application:log-stream:kinesis-analytics-log-stream"
        ]
      }
    ]
    }

  )
}

resource "aws_iam_role_policy_attachment" "a" {
  role       = aws_iam_role.nyc-kinesis-analytics-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_role_policy_attachment" "b" {
  role       = aws_iam_role.nyc-kinesis-analytics-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "c" {
  role       = aws_iam_role.nyc-kinesis-analytics-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccessV2"
  
}