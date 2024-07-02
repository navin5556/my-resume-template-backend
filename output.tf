# Output the hosted zone ID
output "route53_zone_id" {
  value = aws_route53_zone.main.zone_id
}
# Output the NS records for the hosted zone
output "route53_ns_records" {
  value = aws_route53_zone.main.name_servers
}

# Output the bucket name
output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}