variable "private_key" {
  type        = string
  description = "Enter the key value pair for ssh"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "my_ip" {
  type = string
  description = "my ip for ssh"
}