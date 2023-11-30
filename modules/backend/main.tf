
# Define the S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "asg-lb-terraform-state-bucket"

  tags = {
    Name      = "state-file-bucket"
    Terraform = "true"
  }
}
/*
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}*/

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Define the DynamoDB table for state locking
resource "aws_dynamodb_table" "my_lock_table" {
  name           = "my-terraform-lock-table"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
