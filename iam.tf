# # Iam role for the Kinesis Analytics application

# resource "aws_iam_role" "nyc-kinesis-analytics-role" {
#   name = "nyc-kinesis-analytics-role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "kinesisanalytics.amazonaws.com"
#         }
#       }
#     ]
#   })

#   tags = {
#     env = "tf"
#   }
# }

# resource "aws_iam_role_policy" "nyc-kinesis-analytics-role-policy" {
#   name = "nyc-kinesis-analytics-role-policy"
#   role = aws_iam_role.nyc-kinesis-analytics-role.id

#   policy = jsonencode(

#   )
# }