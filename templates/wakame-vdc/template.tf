resource "wakamevdc_security_group" "monitoring_security_group" {
  display_name = "MonitoringSecurityGroup"
  description = "Enable HTTP access via port 80, Zabbix-agent access"
  rules = "tcp:80,80,ip4:0.0.0.0\ntcp:10051,10051,ip4:10.0.0.0/16"
}

resource "wakamevdc_instance" "monitoring_server" {
  display_name = "MonitoringServer"
  cpu_cores = 1
  memory_size = 512
  image_id = "${var.monitoring_image}"
  hypervisor = "kvm"
  ssh_key_id = "${var.ssh_key_id}"

  vif {
    network_id = "${var.private_network}"
    security_groups = [
      "${var.shared_security_group}",
      "${wakamevdc_security_group.monitoring_security_group.id}"
    ]
  }
  vif {
    network_id = "${var.public_network}"
    security_groups = [
      "${var.shared_security_group}",
      "${wakamevdc_security_group.monitoring_security_group.id}"
    ]
  }
}

output "cluster_addresses" {
  value = "${wakamevdc_instance.monitoring_server.vif.0.ip_address}"
}

output "frontend_addresses" {
  value = "${wakamevdc_instance.monitoring_server.vif.1.ip_address}"
}
