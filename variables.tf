variable "key_pair_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "disk_sizes" {
    description = "Root disk size per OS (GB)"
    type        = map(number)
}

variable "allowed_ssh_cidr" {
  description = "Allowed CIDR blocks for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
