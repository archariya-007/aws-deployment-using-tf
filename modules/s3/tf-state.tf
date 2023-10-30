# resource "aws_s3_bucket" "terraform-state" {
#   bucket = var.bucket_name
#   force_destroy = true
#   tags = {
#     Name        = var.bucket_name
#     Environment = var.environment
#   }
# }

resource "aws_s3_bucket_versioning" "terrform-bucket-versioning" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terrform-state-crypto_conf" {
  bucket = aws_s3_bucket.terraform-state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


# Dynamo DB locking TF config
# resource "aws_dynamodb_table" "terraform-locks" {
#   name = "terraform-state-locking"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }