# resource "aws_opensearch_domain" "nyc-taxi-domain" {
#   domain_name    = "nyc-taxi-domain"
#   engine_version = "OpenSearch_2.13"

#   cluster_config {
#     instance_type = "r4.large.search"
#   }

#   tags = {
#     Domain = "TestDomain"
#   }
# }