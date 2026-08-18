provider "oci" {
  auth = "APIKey"

  user_ocid    = var.user_ocid
  tenancy_ocid = var.tenancy_ocid
  region       = var.region

  private_key_path = var.oci_private_key_path
  fingerprint      = var.fingerprint
}

terraform {
  backend "oci" {
    # Required
    bucket    = "terraform-bucket"
    namespace = "axkjllkftxfz"

    # Optional
    tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaats3vpt43eyb7d6djyot4nzy4d7qqe4ajiwr2vnn2rbffcdo34nq"
    user_ocid        = "ocid1.user.oc1..aaaaaaaab5xjd62jdcktnfekagojgslbmg47nnejbw2j32z3p7whkmyfzeeq"
    fingerprint      = "6f:1a:52:ac:17:20:34:6a:a8:8f:51:92:03:61:16:3e"
    private_key_path = "C:/Users/Morsi/.ssh/mo.morsi2004@gmail.com-2026-08-18T17_16_40.482Z.pem"
    region           = "me-jeddah-1"
  }
}