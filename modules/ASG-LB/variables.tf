/*variable "public_subnet_id" {
    type = string
}*/

variable "sg_id" {
  type = string

}

variable "vpc_id" {
  type = string

}

variable "az" {
  type    = list(any)
  default = ["ap-south-1a", "ap-south-1b"]
}


variable "public_subnets" {
  type = list(any)
}

variable "instance_id" {
  type = string
}

variable "ami_id" {
  type = string
}
