#Set the required terraform and provider versions.
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}


#Define the connection, in this case, it is connecting to the local machine.
provider "libvirt" {
  uri = "qemu:///system"
}
