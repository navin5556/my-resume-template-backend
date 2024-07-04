
# Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "aws-cloud-resume-challenge-bucket"  # Replace with your desired bucket name

  tags = {
    Name = "aws-cloud-resume-challenge-bucket",
    Project = "cloud-resume-challenge"
  }
}


# Update the S3 bucket policy to allow access from CloudFront OAI
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        },
        Action   = "s3:GetObject",
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      }
    ]
  })
}
