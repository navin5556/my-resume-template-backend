provider "aws" {
  alias  = "useast1"
  region = "us-east-1"
}


# This resource requests an ACM certificate for your domain
# Route53 DNS validation for the certificate in us-east-1
resource "aws_acm_certificate" "cert_useast1" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider          = aws.useast1
  lifecycle {
    create_before_destroy = true #lifecycle: Ensures that the certificate is created before destroying the old one, to avoid downtime.
  }

  tags = {
    Name = "devopsnaveen.info",
    Project = "cloud-resume-challenge"
  }
}

# This resource creates DNS records in Route 53 to validate the ACM certificate.
# for Expression: Used to create a map or list by iterating over a collection.
# The for_each meta-argument allows you to create multiple instances of a resource or module based on the items in a map or set. 
# In your example, for_each is used to create multiple Route53 records:
resource "aws_route53_record" "cert_validation_useast1" {
  for_each = {
    for dvo in aws_acm_certificate.cert_useast1.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.main.zone_id  # Reference the created Route53 hosted zone
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# This resource waits for the ACM certificate to be validated.
resource "aws_acm_certificate_validation" "cert_useast1" {
  provider               = aws.useast1
  certificate_arn         = aws_acm_certificate.cert_useast1.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_useast1 : record.fqdn]
}
