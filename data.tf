data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "bucket-722141136946-lab"
    key    = "network/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}