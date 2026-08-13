# Private key for OCI Auth
oci_private_key_path = "C:/Users/Mohamed Morsi/.ssh/mo.morsi2004@gmail.com-2026-08-11T17_26_57.040Z.pem"
# Public .SSH key to provide for the private Compute Instance
instance_ssh_public_key = "C:/Users/Mohamed Morsi/.ssh/ssh-key-2026-08-10.key.pub"
# Public .SSH key to provide for the Jump Server
jump_ssh_public_key = "C:/Users/Mohamed Morsi/.ssh/ssh-jump.pub"

# Configuration
user_ocid    = "ocid1.user.oc1..aaaaaaaab5xjd62jdcktnfekagojgslbmg47nnejbw2j32z3p7whkmyfzeeq"
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaaats3vpt43eyb7d6djyot4nzy4d7qqe4ajiwr2vnn2rbffcdo34nq"
region       = "me-jeddah-1"
fingerprint  = "b1:67:59:22:ba:d3:85:56:b6:17:ad:66:39:47:75:30"

# Resources
compartment_id = "ocid1.compartment.oc1..aaaaaaaafwmdm2p6bpr26jkkgoaa25oy3ftx2s2fosnnopqnrc2i7dwzikqa"

# Networking
vcn_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
ingress_public_sl_rules = [
  {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    port        = 443
  },
  {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    port        = 80
  }
]
egress_public_sl_rules = [
  {
    protocol         = "6"
    destination      = "10.0.2.0/24"
    destination_type = "CIDR_BLOCK"
    port             = 22
  },
  {
    protocol         = "6"
    destination      = "10.0.2.0/24"
    destination_type = "CIDR_BLOCK"
    port             = 80
  }
]

# Compute
instance_shape                    = "VM.Standard.E5.Flex"
instance_ocpus                    = 1
instance_memory_in_gbs            = 12
os_image_operating_system         = "Oracle Linux"
os_image_operating_system_version = "9"