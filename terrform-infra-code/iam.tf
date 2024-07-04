# Define IAM role resource for the Lambda function
resource "aws_iam_role" "lambda_for_lambda" {
  name = "aws-cloud-resume-challenge-role"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = "lambda.amazonaws.com"
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

# Define a customer-managed policy for Lambda
resource "aws_iam_policy" "lambda_custom_policy" {
  name        = "lambda_custom_policy"                     # Name of the custom IAM policy
  description = "Custom policy for Lambda to access DynamoDB and CloudWatch" # Description of the custom policy

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Scan",
        "dynamodb:Query"
      ],
      "Resource": "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.myfunc.function_name}:*"
    }
  ]
}
EOF
}

# Attach the custom-managed policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attachment" {
  role       = aws_iam_role.lambda_for_lambda.name          # Name of the IAM role to attach the policy to
  policy_arn = aws_iam_policy.lambda_custom_policy.arn      # ARN of the custom IAM policy to attach
}
