
# Create CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.bucket.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for devopsnaveen.info"
  default_root_object = "index.html"

  aliases = ["resume.devopsnaveen.info"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # Options: 'none', 'whitelist', or 'blacklist'
      # locations        = ["US", "CA", "GB", "DE"]  # no need in case of "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert_useast1.arn
    ssl_support_method              = "sni-only"
    minimum_protocol_version        = "TLSv1.2_2021"
  }

  tags = {
    Name = "devopsnaveen-info-cdn",
    Project = "cloud-resume-challenge"
  }
}

# Create CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 bucket"
}


# The ACM certificate used for CloudFront must be in the us-east-1 (N. Virginia) region. 
# If your certificate is in the ap-south-1 region, you need to either create a 
# new certificate in the us-east-1 region or import the existing certificate into 
# the us-east-1 region.