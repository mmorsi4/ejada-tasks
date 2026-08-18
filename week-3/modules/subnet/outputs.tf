output "subnet_id" {
  value = oci_core_subnet.this.id
}

output "route_table_id" {
  value = oci_core_route_table.this.id
}

output "security_list_id" {
  value = oci_core_security_list.this.id
}

output "cidr_block" {
  value = oci_core_subnet.this.cidr_block
}
