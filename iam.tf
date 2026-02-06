# IAM Role for EC2 SSM
resource "aws_iam_role" "ssm_role" {
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
    ManagedBy = "Terraform"
    Environment = "dev"
  }
}

# Attach AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "terraform-ec2-ssm-profile-v2"
  role = aws_iam_role.ssm_role.name

  tags = {
    ManagedBy = "Terraform"
    Environment = "dev"
  }
}
