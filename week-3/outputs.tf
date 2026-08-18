output "vcn_id" {
  value = oci_core_vcn.this.id
}

output "cluster_id" {
  value = module.oke.cluster_id
}

output "node_pool_id" {
  value = module.oke.node_pool_id
}

output "api_endpoint_subnet_id" {
  value = module.api_endpoint_subnet.subnet_id
}

output "lb_subnet_id" {
  value = module.lb_subnet.subnet_id
}
