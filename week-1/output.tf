output "week1_public_ip" {
  value = oci_core_public_ip.week1_reserved_ip.ip_address
}

output "week1_mount_target_ip" {
  value = oci_file_storage_mount_target.week1_mount_target.private_ip_ids
}