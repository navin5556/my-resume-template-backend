variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "navin-personal-account"  # change this to your profile name
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-1"  # change this to your preferred region
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "my_lambda_function"
}

variable "s3_bucket" {
  description = "The S3 bucket to upload the Lambda function code"
  type        = string
  default     = "my-lambda-functions-bucket"  # change this to your bucket name
}

variable "s3_key" {
  description = "The S3 key for the Lambda function code"
  type        = string
  default     = "lambda_function.zip"
}
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "cloud-resume-challenge-table"  # replace with your actual table name
}

