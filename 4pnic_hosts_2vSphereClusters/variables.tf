variable "vcenter" {
  type = map(string)
  default = {
    fqdn       = "vcsa-01a.corp.local"
    ip         = "192.168.110.22"
    username   = "administrator@vsphere.local"
    password   = "VMware1!"
    dc         = "SDDC"
    compute_manager_name  = "vCenter"
  }
}

variable "nsx" {
  type = map(string)
  default = {
    username = "admin"
    password = "VMware1!VMware1!"
    fqdn     = "lm-paris.corp.local"
  }
}

variable "vsphere_edge_cluster1" {
   type = map(string)
   default = {
     name   = "Cluster-01"
     vds    = "VDS01"
     host1  = "192.168.120.151"
     host2  = "192.168.120.152"
     datastore  = "ds-site-a-nfs01"
     mgmt_dvpg  = "vds01-mgmt"
     left_uplink_vlan = "100"
     right_uplink_vlan = "200"
     edge01_mgmt_ip = "192.168.110.191"
     edge02_mgmt_ip = "192.168.110.192"
     edge03_mgmt_ip = "192.168.110.193"
     edge04_mgmt_ip = "192.168.110.194"
     edge_mgmt_gateway_ip = "192.168.110.1"
     edge_mgmt_prefix_length = "24"
     edge_tep_vlan_id = "130"
     edge_tep_cidr = "192.168.130.0/24"
     edge_tep_gateway = "192.168.130.1"
     edge_tep_start = "192.168.130.2"
     edge_tep_end   = "192.168.130.254"
  }
}

variable "vsphere_edge_cluster2" {
   type = map(string)
   default = {
     name   = "Cluster-02"
     vds    = "VDS02"
     host1  = "192.168.110.151"
     host2  = "192.168.110.152"
     datastore  = "ds-site-a-nfs02"
     mgmt_dvpg  = "vds02-mgmt"
     left_uplink_vlan = "300"
     right_uplink_vlan= "400"
     edge01_mgmt_ip = "192.168.210.191"
     edge02_mgmt_ip = "192.168.210.192"
     edge03_mgmt_ip = "192.168.210.193"
     edge04_mgmt_ip = "192.168.210.194"
     edge_mgmt_gateway_ip = "192.168.210.1"
     edge_mgmt_prefix_length = "24"
     edge_tep_vlan_id = "230"
     edge_tep_cidr = "192.168.230.0/24"
     edge_tep_gateway = "192.168.230.1"
     edge_tep_start = "192.168.230.2"
     edge_tep_end   = "192.168.230.254"
  }
}


variable "edge_nodes" {
   type = map(string)
   default = {
     password   = "VMware1!VMware1!"
     form_factor = "MEDIUM"
     enable_ssh = "true"
     allow_ssh_root_login = "true"
   }
}
