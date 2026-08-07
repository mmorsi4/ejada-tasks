variable "security_list_display_name" {
  type = string
}

variable "security_list_ingress_security_rules_protocol" {
  type = string
}

variable "security_list_ingress_security_rules_source" {
  type = string
}

variable "security_list_ingress_security_rules_stateless" {
  type = bool
}

variable "security_list_rule_1_destination_port" {
  type = number
}

variable "security_list_rule_2_destination_port" {
  type = number
}
