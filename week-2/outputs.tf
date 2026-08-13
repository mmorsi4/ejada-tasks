output "vcn_id" {
  value = oci_core_vcn.vcn.id
}

output "public_subnet_id" {
  value = oci_core_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = oci_core_subnet.private_subnet.id
}

output "instance_private_ip" {
  value = oci_core_instance.instance.private_ip
}

output "jump_server_public_ip" {
  value = oci_core_instance.jump.public_ip
}

output "load_balancer_public_ip" {
  value = oci_load_balancer_load_balancer.lb.ip_address_details[0].ip_address
}

output "file_system_export_path" {
  value = oci_file_storage_export.export.path
}
