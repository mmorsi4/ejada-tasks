terraform {
  backend "oci" {
    # Required
    bucket    = "terraform-bucket"
    namespace = "axkjllkftxfz"

    # Optional
    tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaaats3vpt43eyb7d6djyot4nzy4d7qqe4ajiwr2vnn2rbffcdo34nq"
    user_ocid        = "ocid1.user.oc1..aaaaaaaab5xjd62jdcktnfekagojgslbmg47nnejbw2j32z3p7whkmyfzeeq"
    fingerprint      = "b1:67:59:22:ba:d3:85:56:b6:17:ad:66:39:47:75:30"
    private_key_path = "C:/Users/Mohamed Morsi/.ssh/mo.morsi2004@gmail.com-2026-08-11T17_26_57.040Z.pem"
    region           = "me-jeddah-1"
  }
}