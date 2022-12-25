# Declare the provider (in this case, AWS)
provider "aws" {
  region = "us-east-1"
}

# Create the EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "arn:aws:iam::123456789012:role/EksServiceRole"
}

# Create an IAM role for the worker nodes
resource "aws_iam_role" "node_role" {
  name = "eks-node-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the Amazon EKS worker node IAM policy to the worker node role
resource "aws_iam_policy_attachment" "node_policy" {
  name       = "eks-node-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [aws_iam_role.node_role.name]
}

# Create an Amazon EC2 security group for the worker nodes
resource "aws_security_group" "node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = "vpc-12345678"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }
}

# Create an Amazon EC2 key pair for connecting to the worker nodes
resource "aws_key_pair" "node_key" {
  key_name   = "eks-node-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1KxuN/V7X9oY
