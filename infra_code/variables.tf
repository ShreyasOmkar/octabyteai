variable "aws-region" {
  type    = string
  default = "ap-south-1"
}
variable "environment" {
  type = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "environment must be staging or production."
  }
}
variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"
}
variable "public_subnet" {
  type    = list(string)
  default = ["10.20.0.0/24", "10.20.1.0/24"]
}
variable "private_subnet" {
  type    = list(string)
  default = ["10.20.10.0/24", "10.20.11.0/24"]
}
variable "image" {
  type        = string
  description = "Image ECR uri including digest or commit-SHA tag"
}
variable "db_name" {
  type    = string
  default = "appdb"
}
variable "db_user" {
  type      = string
  default   = "appuser"
  sensitive = true
}
variable "db_instance" {
  type    = string
  default = "db.t4g.micro"
}
variable "count" {
  type    = number
  default = 1
  validation {
    condition     = var.count > 1
    error_message = "Minimum of 1 task is required"
  }
}
variable "protection" {
  type    = bool
  default = true
}
variable "tags" {
  type = map(string)
  default = {
    "Project" = "octabyte-ai"
  }
}
