resource "oci_core_instance" "cloud2solutions_instance" {
  count               = 1
  availability_domain = "CYsl:SA-SAOPAULO-1-AD-1"
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "instancia_centos7_cloud2solutions ${count.index + 1}"

  source_details {
    source_id   = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaay5dutyes76sqfvvn6oozqhujez3m6zxd3yzvg34rbo242vzbvx6q"
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.cloud2solutions_subnet.id
  }

  resource "tls_private_key" "ssh" {
    algorithm = "RSA"
    rsa_bits  = "4096"
  }

  resource "local_file" "ssh_private_key" {
    content         = tls_private_key.ssh.private_key_pem
    filename        = "id_rsa"
    file_permission = "0600"
  }

  resource "local_file" "ssh_public_key" {
    content         = tls_private_key.ssh.public_key_openssh
    filename        = "id_rsa.pub"
    file_permission = "0600"
  }

  locals {
    authorized_keys = [chomp(tls_private_key.ssh.public_key_openssh)]
  }
}