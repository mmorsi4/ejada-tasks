resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_id
  vcn_id             = var.vcn_id
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  type               = "ENHANCED_CLUSTER"

  endpoint_config {
    subnet_id            = var.api_endpoint_subnet_id
    is_public_ip_enabled = var.is_api_endpoint_public
  }

  cluster_pod_network_options {
    cni_type = var.cni_type
  }

  options {
    service_lb_subnet_ids = var.service_lb_subnet_ids

    kubernetes_network_config {
      pods_cidr     = var.cni_type == "FLANNEL_OVERLAY" ? var.pods_cidr : null
      services_cidr = var.services_cidr
    }

    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
  }

  freeform_tags = var.freeform_tags
}

resource "oci_containerengine_node_pool" "this" {
  compartment_id     = var.compartment_id
  cluster_id         = oci_containerengine_cluster.this.id
  name               = var.node_pool_name
  kubernetes_version = var.kubernetes_version
  node_shape         = var.node_shape

  dynamic "node_shape_config" {
    for_each = var.node_ocpus != null ? [1] : []
    content {
      ocpus         = var.node_ocpus
      memory_in_gbs = var.node_memory_gbs
    }
  }

  node_source_details {
    image_id    = var.node_image_ocid
    source_type = "IMAGE"
  }

  node_config_details {
    size = var.node_pool_size

    dynamic "placement_configs" {
      for_each = var.availability_domains
      content {
        availability_domain = placement_configs.value
        subnet_id           = var.worker_subnet_id
      }
    }

    dynamic "node_pool_pod_network_option_details" {
      for_each = var.cni_type == "OCI_VCN_IP_NATIVE" ? [1] : []
      content {
        cni_type       = "OCI_VCN_IP_NATIVE"
        pod_subnet_ids = [var.pod_subnet_id]
      }
    }

    dynamic "node_pool_pod_network_option_details" {
      for_each = var.cni_type == "FLANNEL_OVERLAY" ? [1] : []
      content {
        cni_type = "FLANNEL_OVERLAY"
      }
    }
  }

  ssh_public_key = var.ssh_public_key

  initial_node_labels {
    key   = "name"
    value = var.cluster_name
  }
}
