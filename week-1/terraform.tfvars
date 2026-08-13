# Private key for OCI Auth
oci_private_key_path="C:/Users/Morsi/.ssh/mo.morsi2004@gmail.com-2026-08-07T11_50_07.880Z.pem"
# Public .SSH key to provide for Compute Instance
instance_ssh_public_key="C:/Users/Morsi/.ssh/week1_instance.pub"

# Configuration
user_ocid="ocid1.user.oc1..aaaaaaaab5xjd62jdcktnfekagojgslbmg47nnejbw2j32z3p7whkmyfzeeq"
tenancy_ocid="ocid1.tenancy.oc1..aaaaaaaaats3vpt43eyb7d6djyot4nzy4d7qqe4ajiwr2vnn2rbffcdo34nq"
region="me-jeddah-1"
fingerprint="47:ee:b3:ca:89:db:97:51:bc:cf:26:ff:84:cd:4f:f3"

# Resources
compartment_id="ocid1.compartment.oc1..aaaaaaaafwmdm2p6bpr26jkkgoaa25oy3ftx2s2fosnnopqnrc2i7dwzikqa"

vcn_cidr_block="10.0.0.0/16"
vcn_display_name="Week 1 VCN"

subnet_cidr_block="10.0.1.0/24"
subnet_display_name="Week 1 Public Subnet"

internet_gateway_enabled=true
internet_gateway_display_name="Week 1 Public Gateway"

route_table_display_name="Week 1 Route Table"
route_table_route_rules_description="Allow routing to the internet"
route_table_route_rules_destination="0.0.0.0/0"

security_list_display_name="Week 1 Security List"
security_list_ingress_security_rules_protocol=6 # for tcp
security_list_ingress_security_rules_source="0.0.0.0/0"
security_list_ingress_security_rules_stateless=false
security_list_rule_1_destination_port=80
security_list_rule_2_destination_port=443

instance_availability_domain="oXVt:ME-JEDDAH-1-AD-1"
instance_shape="VM.Standard2.24"
instance_create_vnic_details_assign_public_ip=false
instance_display_name="Week 1 Compute Instance"
instance_image_ocid="ocid1.image.oc1.me-jeddah-1.aaaaaaaazooaavj6reaqev6dnbdpcophwdkgneefajkzzkvsffpx2yfdn6qa"

block_volume_display_name="Week 1 Block Volume"
block_volume_size=50
block_volume_attachment_type="paravirtualized"

file_system_display_name="Week 1 File System"
mount_target_display_name="Week 1 Mount Target"
file_system_export_path="/week1"