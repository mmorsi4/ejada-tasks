# OCI Auth
user_ocid            = "ocid1.user.oc1..aaaaaaaab5xjd62jdcktnfekagojgslbmg47nnejbw2j32z3p7whkmyfzeeq"
tenancy_ocid         = "ocid1.tenancy.oc1..aaaaaaaaats3vpt43eyb7d6djyot4nzy4d7qqe4ajiwr2vnn2rbffcdo34nq"
region               = "me-jeddah-1"
fingerprint          = "6f:1a:52:ac:17:20:34:6a:a8:8f:51:92:03:61:16:3e"
oci_private_key_path = "C:/Users/Morsi/.ssh/mo.morsi2004@gmail.com-2026-08-18T17_16_40.482Z.pem"

# Resources
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaafwmdm2p6bpr26jkkgoaa25oy3ftx2s2fosnnopqnrc2i7dwzikqa"

# Networking
vcn_cidr             = "10.0.0.0/16"
k8s_api_subnet_cidr  = "10.0.0.0/29"
workers_subnet_cidr  = "10.0.1.0/24"
pods_subnet_cidr     = "10.0.32.0/19"
lb_subnet_cidr       = "10.0.2.0/24"

# OKE cluster / node pool
kubernetes_version = "v1.36.1"
node_shape         = "VM.Standard.E4.Flex"
node_ocpus         = 2
node_memory_gbs    = 16
node_pool_size     = 2

# oci ce node-pool-options get --node-pool-option-id all --compartment-id ocid1.compartment.oc1..aaaaaaaafwmdm2p6bpr26jkkgoaa25oy3ftx2s2fosnnopqnrc2i7dwzikqa
node_image_ocid = "ocid1.image.oc1.me-jeddah-1.aaaaaaaawv57iy2lnhx6j22eb7uj6qyjoqabfumwu75eew7v6vt5h5d3pjoa"

# SSH key for worker nodes
ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJ5v8BMHq5BMuKmdflrZ18K5/h02luWcxuDNf15EI+I morsi@DESKTOP-HBR8O6N"
