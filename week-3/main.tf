# Example 3: OCI CNI, public K8s API endpoint, private workers/pods, public LB
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengnetworkconfigexample.htm#example-oci-cni-publick8sapi_privateworkers_publiclb

locals {
  all_services_cidr = data.oci_core_services.all_oci_services.services[0].cidr_block
}

# ---- API endpoint subnet (public) ----
module "api_endpoint_subnet" {
  source = "./modules/subnet"

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "k8sApiEndpoint"
  dns_label      = "apiendpoint"
  cidr_block     = var.k8s_api_subnet_cidr
  is_public      = true

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      network_entity_id = oci_core_internet_gateway.this.id
      description       = "Internet access for public API endpoint"
    }
  ]

  ingress_security_rules = [
    { protocol = "6", source = var.workers_subnet_cidr, tcp_options = { min = 6443, max = 6443 }, description = "Workers to API" },
    { protocol = "6", source = var.workers_subnet_cidr, tcp_options = { min = 12250, max = 12250 }, description = "Workers to control plane" },
    { protocol = "1", source = var.workers_subnet_cidr, icmp_options = { type = 3, code = 4 }, description = "Path discovery" },
    { protocol = "6", source = var.pods_subnet_cidr, tcp_options = { min = 6443, max = 6443 }, description = "Pods to API" },
    { protocol = "6", source = var.pods_subnet_cidr, tcp_options = { min = 12250, max = 12250 }, description = "Pods to control plane" },
    { protocol = "6", source = "0.0.0.0/0", tcp_options = { min = 6443, max = 6443 }, description = "External kubectl access" },
  ]

  egress_security_rules = [
    { protocol = "6", destination = local.all_services_cidr, destination_type = "SERVICE_CIDR_BLOCK", description = "Control plane to OCI services" },
    { protocol = "1", destination = local.all_services_cidr, destination_type = "SERVICE_CIDR_BLOCK", icmp_options = { type = 3, code = 4 }, description = "Path discovery" },
    { protocol = "6", destination = var.workers_subnet_cidr, tcp_options = { min = 10250, max = 10250 }, description = "API to kubelet" },
    { protocol = "1", destination = var.workers_subnet_cidr, icmp_options = { type = 3, code = 4 }, description = "Path discovery" },
    { protocol = "all", destination = var.pods_subnet_cidr, description = "API to pods" },
    { protocol = "6", destination = "0.0.0.0/0", tcp_options = { min = 443, max = 443 }, description = "Outbound HTTPS (Cloud Shell shares this subnet - OCI CLI/auth access)" },
  ]
}

# ---- Worker nodes subnet (private) ----
module "workers_subnet" {
  source = "./modules/subnet"

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "workerNodes"
  dns_label      = "workers"
  cidr_block     = var.workers_subnet_cidr
  is_public      = false

  route_rules = [
    {
      destination       = local.all_services_cidr
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.this.id
      description       = "OCI services via service gateway"
    },
    {
      destination       = "0.0.0.0/0"
      network_entity_id = oci_core_nat_gateway.this.id
      description       = "Internet access for pulling images from public registries (Docker Hub, since OCIR is unavailable)"
    }
  ]

  ingress_security_rules = [
    { protocol = "6", source = var.k8s_api_subnet_cidr, tcp_options = { min = 10250, max = 10250 }, description = "API endpoint to kubelet" },
    { protocol = "1", source = "0.0.0.0/0", icmp_options = { type = 3, code = 4 }, description = "Path discovery" },
    { protocol = "6", source = var.lb_subnet_cidr, tcp_options = { min = 30000, max = 32767 }, description = "LB to NodePort services" },
    { protocol = "6", source = var.lb_subnet_cidr, tcp_options = { min = 10256, max = 10256 }, description = "LB to kube-proxy" },
  ]

  egress_security_rules = [
    { protocol = "all", destination = var.pods_subnet_cidr, description = "Workers to pods" },
    { protocol = "1", destination = "0.0.0.0/0", icmp_options = { type = 3, code = 4 }, description = "Path discovery" },
    { protocol = "6", destination = local.all_services_cidr, destination_type = "SERVICE_CIDR_BLOCK", description = "Workers to OCI services" },
    { protocol = "6", destination = var.k8s_api_subnet_cidr, tcp_options = { min = 6443, max = 6443 }, description = "Workers to API" },
    { protocol = "6", destination = var.k8s_api_subnet_cidr, tcp_options = { min = 12250, max = 12250 }, description = "Workers to control plane" },
    { protocol = "6", destination = "0.0.0.0/0", tcp_options = { min = 443, max = 443 }, description = "Pull images from public registries (Docker Hub)" },
  ]
}

# ---- Pods subnet (private, VCN-native) ----
module "pods_subnet" {
  source = "./modules/subnet"

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "pods"
  dns_label      = "pods"
  cidr_block     = var.pods_subnet_cidr
  is_public      = false

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      network_entity_id = oci_core_nat_gateway.this.id
      description       = "Internet access via NAT for pods"
    },
    {
      destination       = local.all_services_cidr
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.this.id
      description       = "OCI services via service gateway"
    }
  ]

  ingress_security_rules = [
    { protocol = "all", source = var.workers_subnet_cidr, description = "Workers to pods" },
    { protocol = "all", source = var.k8s_api_subnet_cidr, description = "API endpoint to pods" },
    { protocol = "all", source = var.pods_subnet_cidr, description = "Inter-pod communication" },
  ]

  egress_security_rules = [
    { protocol = "all", destination = var.pods_subnet_cidr, description = "Inter-pod communication" },
    { protocol = "1", destination = local.all_services_cidr, destination_type = "SERVICE_CIDR_BLOCK", icmp_options = { type = 3, code = 4 }, description = "Path discovery" },
    { protocol = "6", destination = local.all_services_cidr, destination_type = "SERVICE_CIDR_BLOCK", description = "Pods to OCI services" },
    { protocol = "6", destination = "0.0.0.0/0", tcp_options = { min = 443, max = 443 }, description = "Pods to internet (HTTPS)" },
    { protocol = "6", destination = var.k8s_api_subnet_cidr, tcp_options = { min = 6443, max = 6443 }, description = "Pods to API" },
    { protocol = "6", destination = var.k8s_api_subnet_cidr, tcp_options = { min = 12250, max = 12250 }, description = "Pods to control plane" },
  ]
}

# ---- Load balancer subnet (public) ----
module "lb_subnet" {
  source = "./modules/subnet"

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "loadBalancers"
  dns_label      = "lb"
  cidr_block     = var.lb_subnet_cidr
  is_public      = true

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      network_entity_id = oci_core_internet_gateway.this.id
      description       = "Internet access for public LB"
    }
  ]

  ingress_security_rules = [
    { protocol = "6", source = "0.0.0.0/0", tcp_options = { min = 80, max = 80 }, description = "HTTP" },
    { protocol = "6", source = "0.0.0.0/0", tcp_options = { min = 443, max = 443 }, description = "HTTPS" },
  ]

  egress_security_rules = [
    { protocol = "6", destination = var.workers_subnet_cidr, tcp_options = { min = 30000, max = 32767 }, description = "LB to NodePort services" },
    { protocol = "6", destination = var.workers_subnet_cidr, tcp_options = { min = 10256, max = 10256 }, description = "LB to kube-proxy" },
  ]
}

# ---- OKE cluster + node pool ----
module "oke" {
  source = "./modules/oke"

  compartment_id     = var.compartment_ocid
  vcn_id             = oci_core_vcn.this.id
  cluster_name       = "oke-cluster"
  kubernetes_version = var.kubernetes_version

  api_endpoint_subnet_id = module.api_endpoint_subnet.subnet_id
  is_api_endpoint_public = true
  service_lb_subnet_ids  = [module.lb_subnet.subnet_id]

  cni_type         = "OCI_VCN_IP_NATIVE"
  worker_subnet_id = module.workers_subnet.subnet_id
  pod_subnet_id    = module.pods_subnet.subnet_id

  availability_domains = [for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name]

  node_shape      = var.node_shape
  node_ocpus      = var.node_ocpus
  node_memory_gbs = var.node_memory_gbs
  node_pool_size  = var.node_pool_size
  node_image_ocid = var.node_image_ocid
  ssh_public_key  = var.ssh_public_key
}
