variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  default = "ami-08c40ec9ead489470"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Existing EC2 keypair name"
  type = string
}
