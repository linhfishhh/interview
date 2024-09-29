terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
  profile = "interview"
}

terraform {
  backend "s3" {
    profile        = "interview"
    bucket         = "terraform-state-techmaster-interview"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_state_lock"
    key            = "dev/ec2.tfstate"
    encrypt        = true
  }
}
resource "aws_instance" "terraform-state-test" {
  ami           = "ami-01811d4912b4ccb26"
  instance_type = "t2.micro"
}