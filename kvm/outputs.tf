# Show the VMs IPs.
output "ips" {
  description = "IP list for all VMs."
  value =  libvirt_domain.lfce_domain.*.network_interface.0.addresses
}