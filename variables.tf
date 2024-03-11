variable "private_key" {
  type        = string
  description = "Enter the key value pair for ssh"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

# variable "s3_bucket_backend_name" {
#   type        = string
#   description = "Name of the backend s3 bucket"
# }

# variable "backend_profile" {
#   type = string
#   description = "Name of the backend profile"
# }

# variable "role_arn" {
#   type = string
#   description = "Aws arn for the assume role"
# }

# variable "dynamodb_table_backend_name" {
#   type = string
#   description = "Name of the backend dynamodb table"
# }

# variable "backend_key" {
#   type = string
#   description = "Path to store the tfstate file in backend"
# }

variable "my_ip" {
  type = string
  description = "my ip for ssh"
}