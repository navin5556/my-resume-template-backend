resource "aws_dynamodb_table" "my_table" {
  name         = var.dynamodb_table_name  # Name of the DynamoDB table
  billing_mode = "PAY_PER_REQUEST"        # On-demand billing mode
  hash_key     = "id"                     # Primary key attribute for the table

  attribute {
    name = "id"
    type = "S"                            # Attribute type (S for String)
  }

  tags = {
    Name = "MyDynamoDBTable"
  }
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.my_table.name
  hash_key   = aws_dynamodb_table.my_table.hash_key

  item = <<ITEM
{
  "id": {"S": "0"},
  "views": {"N": "1"}
}
ITEM
}