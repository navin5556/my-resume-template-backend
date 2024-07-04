
# Create Route53 hosted zone
resource "aws_route53_zone" "main" {
  name = "devopsnaveen.info"
}

# Create Route53 alias record for CloudFront distribution
resource "aws_route53_record" "test_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "resume.devopsnaveen.info"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
