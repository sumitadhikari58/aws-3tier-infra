variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for naming resources"
  default     = "aws-3tier"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}
variable "developer_ip" {
  description = "Developer IP for SSH access"
  default     = "0.0.0.0/0"
}