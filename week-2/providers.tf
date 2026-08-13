provider "oci" {
  auth = "APIKey"

  user_ocid    = var.user_ocid
  tenancy_ocid = var.tenancy_ocid
  region       = var.region

  private_key_path = var.oci_private_key_path
  fingerprint      = var.fingerprint
}