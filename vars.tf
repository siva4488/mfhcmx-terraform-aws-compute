variable "ami_id" { }
variable "instance_type" { }
variable "instance_count" { }
variable "instance_name" { }
variable "region" { }
variable "access_key" { }
variable "secret_key" { }
variable "sgname" { }
variable "subnet_id" { }
variable "vpc_id" { }
variable "volume_type" { }
variable "volume_size" { }

variable "key_pair" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}
