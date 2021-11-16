#Define the location of the new storage pool.
resource "libvirt_pool" "lfce_pool" {
  name = "lfce_pool"
  type = "dir"
  path = var.pool_path
}

#Add the image in storage pool.
resource "libvirt_volume" "lfce_image" {
  name   = "lfce_image"
  pool   = libvirt_pool.lfce_pool.name
  source = "./lfce_centos7.qcow2"
}

#Create the disk based on the downloaded image.
resource "libvirt_volume" "os_volume" {
  name           = "os_volume-${count.index}"
  base_volume_id = libvirt_volume.lfce_image.id
  count          = var.count_vms
  pool           = libvirt_pool.lfce_pool.name
}

#Create a new network for the VMs.
resource "libvirt_network" "lfce_network" {
  name      = "lfce-network"
  mode      = var.network_mode
  domain    = var.dns_domain
  autostart = true
  dns {
    enabled = true
  }

  addresses = [var.network_cidr]
}

data "template_file" "user_data" {
  template = file("${path.module}/lfce.yaml")
}

#Define the ISO used by cloud-init.
resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = libvirt_pool.lfce_pool.name
}

#Create the VMs.
resource "libvirt_domain" "lfce_domain" {
  name = "lfce-${count.index}"

  cpu {
    mode = "host-passthrough"
  }

  memory = var.memory
  vcpu   = var.vcpu

  cloudinit = libvirt_cloudinit_disk.commoninit.id


  disk {
    volume_id = element(libvirt_volume.os_volume.*.id, count.index)
  }

  network_interface {
    network_name   = "lfce-network"
    hostname       = "lfce-${count.index}"
    wait_for_lease = true
  }

  count = var.count_vms
}
