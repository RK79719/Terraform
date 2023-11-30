variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnet_settings" {
  type = list(object({
    name              = string,
    cidr_block        = string,
    availability_zone = string

  }))
}


variable "private_subnet_settings" {
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string

  }))
}