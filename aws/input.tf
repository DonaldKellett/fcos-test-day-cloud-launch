variable "fcos_ami" {
  type = string
  description = "The AMI ID for our FCOS instance"
  validation {
    condition = can(regex("^ami-", var.fcos_ami))
    error_message = "The fcos_ami value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "fcos_instance_type" {
  type = string
  description = "The instance type to use for our FCOS instance"
  default = "t2.micro"
}
