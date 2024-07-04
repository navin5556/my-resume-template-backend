# Define the Lambda function resource
resource "aws_lambda_function" "myfunc" {
  filename         = data.archive_file.zip.output_path       # Path to the ZIP file containing the Lambda function code
  source_code_hash = data.archive_file.zip.output_base64sha256 # Base64-encoded SHA256 hash of the ZIP file for code integrity verification
  function_name    = "myfunc"                                # Name of the Lambda function
  role             = aws_iam_role.lambda_for_lambda.arn      # ARN of the IAM role that the Lambda function assumes
  handler          = "func.lambda_handler"                          # Handler for the Lambda function, specifying the file and function name
  runtime          = "python3.12"                             # Runtime environment for the Lambda function
}


# Define the Lambda function URL resource
resource "aws_lambda_function_url" "myfunc_url" {
  function_name = aws_lambda_function.myfunc.function_name   # Name of the Lambda function
  authorization_type = "NONE"    # Authorization type for the Lambda function URL
    cors {
    allow_origins = ["https://resume.devopsnaveen.info"]            # Allowed origins for CORS (e.g., "*" to allow all origins)
    allow_methods = ["*"]         # Allowed HTTP methods for CORS
    allow_headers = ["date", "keep-alive"]        # Allowed headers for CORS
    expose_headers = ["keep-alive", "date"]         # Headers exposed to the client
    max_age        = 86400                      # Max age for CORS preflight requests
  }
}

# Define the archive_file data source to create a ZIP file from the specified source directory
data "archive_file" "zip" {
  type        = "zip"                              # Type of archive to create (ZIP)
  source_dir  = "${path.module}/../lambda/"           # Directory containing the Lambda function code to be zipped
  output_path = "${path.module}/packedlambda.zip"  # Path where the created ZIP file will be stored
}

# Data source to get AWS caller identity
# The aws_caller_identity data source retrieves 
# ...information about the AWS caller, such as the AWS account ID, user ID, and ARN
data "aws_caller_identity" "current" {}

