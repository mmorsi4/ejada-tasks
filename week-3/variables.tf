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

variable "compartment_ocid" {
  type        = string
  description = "Compartment where all resources are created"
}

variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "k8s_api_subnet_cidr" {
  type    = string
  default = "10.0.0.0/29"
}

variable "workers_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "pods_subnet_cidr" {
  type    = string
  default = "10.0.32.0/19"
}

variable "lb_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "kubernetes_version" {
  type    = string
  default = "v1.36.1"
}

variable "node_shape" {
  type    = string
  default = "VM.Standard.E4.Flex"
}

variable "node_ocpus" {
  type    = number
  default = 2
}

variable "node_memory_gbs" {
  type    = number
  default = 16
}

variable "node_pool_size" {
  type    = number
  default = 2
}

variable "node_image_ocid" {
  type        = string
  description = "OKE worker node image OCID for the region (get via oci ce node-pool-options get)"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key content for worker nodes"
}
