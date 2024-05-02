variable "vcenter" {
  type = map(string)
  default = {
    fqdn       = "vcsa-01a.corp.local"
    ip         = "192.168.110.22"
    username   = "administrator@vsphere.local"
    password   = "VMware1!"
    dc         = "SDDC" # Name of Datacenter as it appears in vCenter
    compute_manager_name  = "vCenter" #Compute manager name as it appears in NSX
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
     name   = "Cluster-01" # Name of the vSphere cluster as it appears in vCenter
     vds    = "VDS01" # Name of the VDS dedicated to the vSphere cluster as it appears in vCneter. The VDS must manage all 4 vmnics (pNICs) 
     host1  = "192.168.120.151" # IP or FQDN as it appears in vCenter of the first edge host in the cluster
     host2  = "192.168.120.152" # IP or FQDN as it appears in vCenter of the second edge host in the cluster
     datastore  = "ds-site-a-nfs01" #Datastore where the edges will be deployed, same for all edges in this cluster
     mgmt_dvpg  = "vds01-mgmt" #Existing dvpg that will host the management interface of the NSX Edges
     left_uplink_vlan = "100" #Peering VLAN to the left ToR
     right_uplink_vlan = "200" #Peering VLAN to the right ToR
     edge01_mgmt_ip = "192.168.110.191" #Management network IPs hosted in the mgmt_dvpg
     edge02_mgmt_ip = "192.168.110.192"
     edge03_mgmt_ip = "192.168.110.193"
     edge04_mgmt_ip = "192.168.110.194"
     edge_mgmt_gateway_ip = "192.168.110.1"
     edge_mgmt_prefix_length = "24"
     edge01_left_ip = "192.168.254.1/24" #IP of the T0 gateway uplink hosted on edge01 on the left peering VLAN 
     edge02_left_ip = "192.168.254.2/24" #IP of the T0 gateway uplink hosted on edge02 on the left peering VLAN
     edge03_left_ip = "192.168.254.4/24" #IP of the T0 gateway uplink hosted on edge03 on the left peering VLAN
     edge04_left_ip = "192.168.254.5/24" #IP of the T0 gateway uplink hosted on edge04 on the left peering VLAN
     edge01_right_ip = "192.168.253.1/24" #IP of the T0 gateway uplink hosted on edge01 on the right peering VLAN 
     edge02_right_ip = "192.168.253.2/24" #IP of the T0 gateway uplink hosted on edge02 on the right peering VLAN 
     edge03_right_ip = "192.168.253.4/24" #IP of the T0 gateway uplink hosted on edge03 on the right peering VLAN 
     edge04_right_ip = "192.168.253.5/24" #IP of the T0 gateway uplink hosted on edge04 on the right peering VLAN 
     tor_left_ip    = "192.168.254.3" # IP of the left ToR on the left peering VLAN
     tor_right_ip    = "192.168.253.3" # IP of the right ToR on the right peering VLAN
     tor_left_as     = "65100" # BGP AS of the left ToR
     tor_right_as    = "65100" # BGP AS of the right ToR
     edge_tep_vlan_id = "130" # Edge TEP VLAN specific to rack 1
     edge_tep_cidr = "192.168.130.0/24" # CIDR of the Edge TEP VLAN specific to rack 1
     edge_tep_gateway = "192.168.130.1" # Gateway of the Edge TEP VLAN specific to rack 1
     edge_tep_start = "192.168.130.2" # First IP available for allocation in the edge TEP pool
     edge_tep_end   = "192.168.130.254" # Last IP available for allocation in the edge TEP pool
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
     edge01_left_ip = "192.168.252.1/24"
     edge02_left_ip = "192.168.252.2/24"
     edge03_left_ip = "192.168.252.4/24"
     edge04_left_ip = "192.168.252.5/24"
     edge01_right_ip = "192.168.251.1/24"
     edge02_right_ip = "192.168.251.2/24"
     edge03_right_ip = "192.168.251.4/24"
     edge04_right_ip = "192.168.251.5/24"
     tor_left_ip    = "192.168.252.3"
     tor_right_ip    = "192.168.251.3"
     tor_left_as     = "65100"
     tor_right_as    = "65100"
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
     password   = "VMware1!VMware1!" #Edge nodes' intial password
     form_factor = "MEDIUM" # Edge nodes form factor
     enable_t0_firewall = "false" #Do you need stateless firewall on the T0? If not set to false
     t0_urpf_mode = "NONE" #STRICT or NONE 
     enable_ssh = "true"
     allow_ssh_root_login = "true"
     uplink_mtu = "9000" # Should match the MTU of the peering SVIs on the ToRs
     bgp_as = "65002" # BGP AS of the NSX T0 Gateway
   }
}
