provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "bibek-lf-devops-gitops-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bibek_terraform_state"
  }
}

resource "aws_s3_bucket" "tf_backend_bucket" {
  bucket = var.tf_backend_bucket_name
}

resource "aws_s3_bucket_versioning" "tf_backend_bucket_versioning" {
  bucket = aws_s3_bucket.tf_backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "tf_backend_bucket_object_lock" {
  depends_on          = [aws_s3_bucket.tf_backend_bucket]
  bucket              = aws_s3_bucket.tf_backend_bucket.id
  object_lock_enabled = "Enabled"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_backend_bucket_sse" {
  bucket = aws_s3_bucket.tf_backend_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "tf_backend_bucket_state_lock" {
  name           = "bibek_terraform_state"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "Bibek DynamoDB Terraform State Lock Table"
  }
}

resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
}




