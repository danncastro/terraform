resource "oci_core_security_list" "cloud2solutions_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.cloud2solutions_vcn.id
  display_name   = "cloud2solutions_security_list"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = "8080"
      min = "8080"
    }
  }


}