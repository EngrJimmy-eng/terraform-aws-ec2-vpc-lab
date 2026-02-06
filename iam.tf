resource "aws_iam_role" "ec2_ssm" {
  name = "terraform-ec2-ssm-role-clean"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    ManagedBy  = "Terraform"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "terraform-ec2-ssm-profile-v2"
  role = aws_iam_role.ec2_ssm.name
}
