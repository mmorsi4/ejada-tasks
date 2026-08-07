variable "instance_availability_domain" {
  type = string
}

variable "instance_shape" {
  type = string
}

variable "instance_display_name" {
  type = string
}

variable "instance_image_ocid" {
  type = string
}

variable "instance_ssh_public_key" {
  type = string
}

variable "instance_create_vnic_details_assign_public_ip" {
  type = bool
}
