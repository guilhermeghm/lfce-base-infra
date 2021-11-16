#Set the local DNS domain.
variable "dns_domain" {
  description = "DNS domain name"
  default     = "lfce.local"

}

#Set the CIDR.
variable "network_cidr" {
  description = "Network CIDR"
  default     = "10.16.0.0/24"
}

#Set the network type.
variable "network_mode" {
  description = "Network mode"
  default     = "nat"
}

#Set the number of VMs to be created.
variable "count_vms" {
  description = "number of virtual-machine of same type that will be created"
  default     = 4
}

#Define the amount of memoy for each VM.
variable "memory" {
  description = "The amount of RAM (MB) for a VM"
  default     = 2048
}

#Define the number of vCPUs for each VM.
variable "vcpu" {
  description = "The amount of virtual CPUs for a VM"
  default     = 2
}

#Define the path in the host for the storage pool.
variable "pool_path" {
  description = "The path for the storage pool"
  default     = "/lfce-VMs"
}
