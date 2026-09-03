variable "aws_region" {
  description = "AWS region for the Ansible lab"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type used for the lab"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "Invalid instance type. Allowed for this lab are: t3.micro, t3.small only."
  }
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed for SSH access to the lab instances"
  type        = string
}

variable "public_key_path" {
  description = "Path to the SSH public key to use for lab access"
  type        = string
}