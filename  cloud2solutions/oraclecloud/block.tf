resource "oci_core_volume" "volume_cloud2solutions" {
  compartment_id      = var.compartment_id
  availability_domain = "CYsl:SA-SAOPAULO-1-AD-1"
  size_in_gbs         = 50
  display_name        = "volume_cloud2solutions"
}

resource "oci_core_volume_attachment" "cloud2solutions_volume_attachment" {
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.cloud2solutions_instance[0].id
  volume_id       = oci_core_volume.volume_cloud2solutions.id
  display_name    = "cloud2solutions_attachment"
}