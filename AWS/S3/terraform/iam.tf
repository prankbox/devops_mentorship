data "aws_iam_policy" "s3" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "s3full" {
  name               = "S3Full"
  assume_role_policy =<<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "sts:AssumeRole"
        ],
        "Principal": {
            "Service": [
                "ec2.amazonaws.com"
            ]
        }
    }
]
}
EOF


}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.s3full.name
  policy_arn = data.aws_iam_policy.s3.arn

}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.s3full.name
}