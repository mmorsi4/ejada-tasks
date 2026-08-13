### Networking ################################################################

resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr]
  display_name   = "week-2-vcn"
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "week-2-igw"
  enabled        = true
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "week-2-nat"
}

resource "oci_core_route_table" "rt_public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "week-2-rt-public"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_route_table" "rt_private" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "week-2-rt-private"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
}

### Security lists #############################################################

resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "week-2-public-subnet-sl"

  dynamic "ingress_security_rules" {
    for_each = var.ingress_public_sl_rules

    content {
      protocol    = ingress_security_rules.value.protocol
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type

      tcp_options {
        min = ingress_security_rules.value.port
        max = ingress_security_rules.value.port
      }
    }
  }

  dynamic "egress_security_rules" {
    for_each = var.egress_public_sl_rules

    content {
      protocol         = egress_security_rules.value.protocol
      destination      = egress_security_rules.value.destination
      destination_type = egress_security_rules.value.destination_type

      tcp_options {
        min = egress_security_rules.value.port
        max = egress_security_rules.value.port
      }
    }
  }
}

resource "oci_core_security_list" "private_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "week-2-private-subnet-sl"

  # HTTP ingress from the public subnet (load balancer)
  ingress_security_rules {
    protocol    = "6"
    source      = var.public_subnet_cidr
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 80
      max = 80
    }
  }

  # egress to the internet via the NAT gateway (updates, etc.)
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

### Subnets #####################################################################

resource "oci_core_subnet" "public_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.vcn.id
  cidr_block                 = var.public_subnet_cidr
  display_name               = "week-2-public-subnet"
  route_table_id             = oci_core_route_table.rt_public.id
  security_list_ids          = [oci_core_security_list.public_sl.id, oci_core_vcn.vcn.default_security_list_id]
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.vcn.id
  cidr_block                 = var.private_subnet_cidr
  display_name               = "week-2-private-subnet"
  route_table_id             = oci_core_route_table.rt_private.id
  security_list_ids          = [oci_core_security_list.private_sl.id, oci_core_vcn.vcn.default_security_list_id]
  prohibit_public_ip_on_vnic = true
}

### Compute #####################################################################

resource "oci_core_instance" "instance" {
  compartment_id      = var.compartment_id
  availability_domain = local.availability_domain
  display_name        = "week-2-instance"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    assign_public_ip = false
    display_name     = "week-2-instance-vnic"
  }

  source_details {
    source_type = "image"
    source_id   = local.image_id
  }

  metadata = {
    ssh_authorized_keys = file(var.instance_ssh_public_key)
  }
}

resource "oci_core_instance" "jump" {
  compartment_id      = var.compartment_id
  availability_domain = local.availability_domain
  display_name        = "week-2-jump"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    assign_public_ip = true
    display_name     = "week-2-jump-vnic"
  }

  source_details {
    source_type = "image"
    source_id   = local.image_id
  }

  metadata = {
    ssh_authorized_keys = file(var.jump_ssh_public_key)
  }
}

### File storage ################################################################

resource "oci_file_storage_file_system" "fs" {
  compartment_id      = var.compartment_id
  availability_domain = local.availability_domain
  display_name        = "week-2-file-system"
}

resource "oci_file_storage_mount_target" "mount_target" {
  compartment_id      = var.compartment_id
  availability_domain = local.availability_domain
  subnet_id           = oci_core_subnet.private_subnet.id
  display_name        = "week-2-mount-target"
}

resource "oci_file_storage_export" "export" {
  export_set_id  = oci_file_storage_mount_target.mount_target.export_set_id
  file_system_id = oci_file_storage_file_system.fs.id
  path           = "/week-2-file-system"
}

### Load balancer ###############################################################

resource "oci_load_balancer_load_balancer" "lb" {
  compartment_id = var.compartment_id
  display_name   = "week-2-app-lb"
  shape          = "flexible"

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  subnet_ids = [oci_core_subnet.public_subnet.id]
  is_private = false
}

resource "oci_load_balancer_backend_set" "backend_set" {
  name             = "week-2-backend-set"
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol    = "HTTP"
    port        = 80
    url_path    = "/"
    interval_ms = 10000
  }
}

resource "oci_load_balancer_backend" "backend" {
  load_balancer_id = oci_load_balancer_load_balancer.lb.id
  backendset_name  = oci_load_balancer_backend_set.backend_set.name
  ip_address       = oci_core_instance.instance.private_ip
  port             = 80
}

resource "oci_load_balancer_listener" "listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.lb.id
  name                     = "week-2-listener"
  default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
  port                     = 80
  protocol                 = "HTTP"
}
