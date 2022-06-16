data "aws_iam_policy" "s3" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role" "s3full" {
  name               = "S3Full"
  assume_role_policy = data.aws_iam_policy.s3.name
  
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.s3full.name
}