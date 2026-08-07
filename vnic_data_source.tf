data "oci_core_vnic_attachments" "week1_vnic_attachments" {
    compartment_id = var.compartment_id
    instance_id    = oci_core_instance.week1_instance.id
}

data "oci_core_private_ips" "week1_private_ip" {
    vnic_id = data.oci_core_vnic_attachments.week1_vnic_attachments.vnic_attachments[0].vnic_id
}
