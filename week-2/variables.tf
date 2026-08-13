variable "user_ocid" {
  type = string
}

variable "tenancy_ocid" {
  type = string
}

variable "region" {
  type = string
}

variable "oci_private_key_path" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "compartment_id" {
  description = "OCID of the compartment where resources are created"
  type        = string
}

# Networking
variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Compute
variable "instance_shape" {
  description = "Shape used for the private instance and the jump server"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  description = "Number of OCPUs for flex shapes"
  type        = number
  default     = 1
}

variable "instance_memory_in_gbs" {
  description = "Amount of memory (GB) for flex shapes"
  type        = number
  default     = 8
}

variable "os_image_operating_system" {
  description = "Operating system used to look up the compute image"
  type        = string
  default     = "Oracle Linux"
}

variable "os_image_operating_system_version" {
  description = "Operating system version used to look up the compute image"
  type        = string
  default     = "9"
}

# Public .SSH key to provide for the private compute instance
variable "instance_ssh_public_key" {
  description = "Path to the public SSH key installed on the private instance"
  type        = string
}

# Public .SSH key to provide for the jump server
variable "jump_ssh_public_key" {
  description = "Path to the public SSH key installed on the jump server"
  type        = string
}

variable "ingress_public_sl_rules" {
  type = list(object(
    {
      protocol    = string
      source      = string
      source_type = string
      port        = number
    }
    )
  )
}

variable "egress_public_sl_rules" {
  type = list(object(
    {
      protocol         = string
      destination      = string
      destination_type = string
      port             = number
    }
    )
  )
}