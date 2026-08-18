variable "compartment_id" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "oke-cluster"
}

variable "kubernetes_version" {
  type = string
}

variable "api_endpoint_subnet_id" {
  type = string
}

variable "is_api_endpoint_public" {
  type    = bool
  default = true
}

variable "service_lb_subnet_ids" {
  type = list(string)
}

variable "cni_type" {
  description = "OCI_VCN_IP_NATIVE for VCN-native pod networking, or FLANNEL_OVERLAY"
  type        = string
  default     = "OCI_VCN_IP_NATIVE"

  validation {
    condition     = contains(["OCI_VCN_IP_NATIVE", "FLANNEL_OVERLAY"], var.cni_type)
    error_message = "cni_type must be OCI_VCN_IP_NATIVE or FLANNEL_OVERLAY."
  }
}

variable "pods_cidr" {
  description = "Only used for FLANNEL_OVERLAY cni_type"
  type        = string
  default     = "10.244.0.0/16"
}

variable "services_cidr" {
  type    = string
  default = "10.96.0.0/16"
}

# Node pool configuration
variable "node_pool_name" {
  type    = string
  default = "oke-node-pool"
}

variable "worker_subnet_id" {
  type = string
}

variable "pod_subnet_id" {
  description = "Required when cni_type = OCI_VCN_IP_NATIVE"
  type        = string
  default     = null
}

variable "availability_domains" {
  description = "List of ADs to spread node pool placement across"
  type        = list(string)
}

variable "node_shape" {
  type = string
}

variable "node_ocpus" {
  type    = number
  default = null
}

variable "node_memory_gbs" {
  type    = number
  default = null
}

variable "node_pool_size" {
  type = number
}

variable "node_image_ocid" {
  type = string
}

variable "ssh_public_key" {
  type    = string
  default = null
}

variable "freeform_tags" {
  type    = map(string)
  default = {}
}
