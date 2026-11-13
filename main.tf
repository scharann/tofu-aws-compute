resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for lab EC2 instance"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "${var.project_name}-ec2"
  }
}