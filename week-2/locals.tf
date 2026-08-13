locals {
  availability_domain = data.oci_identity_availability_domain.ad.name
  image_id            = data.oci_core_images.oracle_linux.images[0].id
}