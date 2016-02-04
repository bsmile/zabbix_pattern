variable "private_network" {
  description = "Network ID which is created by common network pattern."
}
variable "public_network" {
  description = "Network ID which is created by common network pattern."
}
variable "shared_security_group" {
  description = "SecurityGroup ID which is created by common network pattern."
}
variable "ssh_key_id" {
  description = "Name of an existing KeyPair to enable SSH access to the instances."
}
variable "monitoring_image" {
  description = "[computed] MonitoringServer Image Id. This parameter is automatically filled by CloudConductor."
}
