variable "compartment_id" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "dns_label" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "is_public" {
  type        = bool
  description = "If false, prohibits public IPs on VNICs in this subnet"
  default     = false
}

variable "route_rules" {
  description = "List of route rules for this subnet's route table"
  type = list(object({
    destination       = string
    destination_type  = optional(string, "CIDR_BLOCK")
    network_entity_id = string
    description       = optional(string, null)
  }))
  default = []
}

variable "ingress_security_rules" {
  description = "List of ingress security rules"
  type = list(object({
    protocol    = string # "6" tcp, "17" udp, "1" icmp, "all"
    source      = string
    source_type = optional(string, "CIDR_BLOCK")
    description = optional(string, null)
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  default = []
}

variable "egress_security_rules" {
  description = "List of egress security rules"
  type = list(object({
    protocol         = string
    destination      = string
    destination_type = optional(string, "CIDR_BLOCK")
    description      = optional(string, null)
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  default = []
}

variable "enable_flow_logs" {
  type    = bool
  default = false
}

variable "flow_logs_retention_days" {
  type    = number
  default = 30
}
