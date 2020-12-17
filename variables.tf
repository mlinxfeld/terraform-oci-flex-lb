variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "private_key_oci" {}
variable "public_key_oci" {}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "VCNname" {
  default = "FoggyKitchenVCN"
}

variable "Shapes" {
 default = ["VM.Standard.E3.Flex"]
}

variable "OsImage" {
  default = "Oracle-Linux-7.8-2020.05.26-0"
}

variable "webservice_ports" {
  default = ["80","443"]
}

variable "bastion_ports" {
  default = ["22"]
}

