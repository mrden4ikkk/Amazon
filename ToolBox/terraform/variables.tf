variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "eu-north-1"
}

#variable "public_ip" {
#  type    = string
#  default = ""
#}

variable "key_name" {
  type    = string
  default = "MyKey"
}

variable "elastic_ip_allocation_id" {
  type    = string
  default = "eipalloc-0b7a880b8b9a98bde"
}

