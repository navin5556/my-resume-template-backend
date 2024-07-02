
# Create S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "devopsnaveen-info-bucket"  # Replace with your desired bucket name

  tags = {
    Name = "devopsnaveen-info-bucket"
  }
}


