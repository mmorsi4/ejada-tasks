resource "oci_core_vcn" "week1_vcn" {
    compartment_id = var.compartment_id
    cidr_block     = var.vcn_cidr_block
    display_name   = var.vcn_display_name
}

resource "oci_core_internet_gateway" "week1_igw" {
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.week1_vcn.id
    enabled        = var.internet_gateway_enabled
    display_name   = var.internet_gateway_display_name
}

resource "oci_core_route_table" "week1_rt" {
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.week1_vcn.id
    display_name   = var.route_table_display_name

    route_rules {
        network_entity_id = oci_core_internet_gateway.week1_igw.id
        description       = var.route_table_route_rules_description
        destination       = var.route_table_route_rules_destination
        destination_type  = "CIDR_BLOCK"
    }
}

resource "oci_core_security_list" "week1_sl" {
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.week1_vcn.id
    display_name   = var.security_list_display_name

    # Rule 1 - Allow HTTP
    ingress_security_rules {
        protocol   = var.security_list_ingress_security_rules_protocol
        source     = var.security_list_ingress_security_rules_source
        source_type = "CIDR_BLOCK"
        stateless  = var.security_list_ingress_security_rules_stateless

        tcp_options {
            max = var.security_list_rule_1_destination_port
            min = var.security_list_rule_1_destination_port

            // Omit this part to ensure all source ports
            # source_port_range {
            #     max = var.security_list_ingress_security_rules_tcp_options_source_port_range_max
            #     min = var.security_list_ingress_security_rules_tcp_options_source_port_range_min
            # }
        }
    }

    # Rule 2 - Allow HTTPS
    ingress_security_rules {
        protocol   = var.security_list_ingress_security_rules_protocol
        source     = var.security_list_ingress_security_rules_source
        source_type = "CIDR_BLOCK"
        stateless  = var.security_list_ingress_security_rules_stateless

        tcp_options {
            max = var.security_list_rule_2_destination_port
            min = var.security_list_rule_2_destination_port

            // omit this part to ensure all source ports
            # source_port_range {
            #     max = var.security_list_ingress_security_rules_tcp_options_source_port_range_max
            #     min = var.security_list_ingress_security_rules_tcp_options_source_port_range_min
            # }
        }
    }
}

resource "oci_core_subnet" "week1_public_subnet" {
    compartment_id = var.compartment_id
    vcn_id         = oci_core_vcn.week1_vcn.id
    cidr_block     = var.subnet_cidr_block
    display_name   = var.subnet_display_name

    route_table_id = oci_core_route_table.week1_rt.id
    security_list_ids = [
        oci_core_security_list.week1_sl.id,
        oci_core_vcn.week1_vcn.default_security_list_id
    ]
}

resource "oci_core_instance" "week1_instance" {
    availability_domain = var.instance_availability_domain
    compartment_id      = var.compartment_id
    shape               = var.instance_shape
    display_name        = var.instance_display_name

    create_vnic_details {
        assign_public_ip = var.instance_create_vnic_details_assign_public_ip
        subnet_id        = oci_core_subnet.week1_public_subnet.id
    }

    source_details {
        source_id   = var.instance_image_ocid
        source_type = "image"
    }

    metadata = {
        ssh_authorized_keys = file(var.instance_ssh_public_key)
    }
}

resource "oci_core_public_ip" "week1_reserved_ip" {
    compartment_id = var.compartment_id
    lifetime       = "RESERVED"
    display_name   = "week1-reserved-ip"

    private_ip_id = data.oci_core_private_ips.week1_private_ip.private_ips[0].id
}

resource "oci_core_volume" "week1_block_volume" {
    compartment_id      = var.compartment_id
    availability_domain = var.instance_availability_domain
    display_name        = var.block_volume_display_name
    size_in_gbs         = var.block_volume_size
}

resource "oci_core_volume_attachment" "week1_block_volume_attachment" {
    attachment_type = var.block_volume_attachment_type
    instance_id     = oci_core_instance.week1_instance.id
    volume_id       = oci_core_volume.week1_block_volume.id
}

resource "oci_file_storage_file_system" "week1_file_system" {
    compartment_id      = var.compartment_id
    availability_domain = var.instance_availability_domain
    display_name        = var.file_system_display_name
}

resource "oci_file_storage_mount_target" "week1_mount_target" {
    compartment_id      = var.compartment_id
    availability_domain = var.instance_availability_domain
    subnet_id           = oci_core_subnet.week1_public_subnet.id
    display_name        = var.mount_target_display_name
}

resource "oci_file_storage_export" "week1_export" {
    export_set_id  = oci_file_storage_mount_target.week1_mount_target.export_set_id
    file_system_id = oci_file_storage_file_system.week1_file_system.id
    path           = var.file_system_export_path
}
