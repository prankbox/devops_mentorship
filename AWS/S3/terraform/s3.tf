resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

locals {
  s3_bucket_name = "${var.s3_bucket}and${random_string.suffix.result}"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = local.s3_bucket_name
  force_destroy = true
  tags = {
    "Name"        = "${local.s3_bucket_name}"
    "Description" = "S3 Bucker for logs"
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Disabled"
  }
}
