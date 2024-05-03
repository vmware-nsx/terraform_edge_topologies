# L3 Aware Edge Design for VCF
## Rack Layout

This folder includes the Terraform files to deploy NSX edge nodes in the following topology:
* Rack separated by L3 boundary in the physical fabric, no VLAN/subnet shared across racks.
* Two Independent vSphere clusters dedicated to NSX edges, one per rack.
* Minimum of 3 hosts per vSphere cluster if using VSAN, 2 if using NFS
* 4 pNIC hosts
* 1 VDS per cluster, single VDS controlling all 4 pNICs
* 2 edge nodes per host (Large or XL edge VM form factor recommended), 4 total per vSphere cluster, placed deterministically on a specific host via DRS should rules
* Single Tier-0 Gateway A/A Stateless spanning all 8 edge nodes across the two racks/vSphere cluster
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/Rack_layout.png?raw=true)

## VDS Configuration
VDSs (One per cluster) are created by the SDDC manager cluster creation workflow. An edge management dvpg must be created manually before using Terrfaorm to deploy the edges. All other VDS configurations and dvpg creation are automated via Terraform. The objects created by Terraform are presented in blue in the diagram, in purple/violet those must be present in advance.
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/VDSs.png?raw=true)

## NSX Edge host switch configuration 
Edge nodes are deployed following the model presented by the VCF and NSX Design guides. Only two data path interfaces are in use, both managed by the same host switch (AKA NVDS). The two data path interfaces are shared by the VLAN uplinks to the physical network and by the two TEP interfaces for overlay traffic. Please refer to the [NSX Design guide, chapter 7](https://nsx.techzone.vmware.com/resource/nsx-reference-design-guide#nsx-design-considerations) for more insight into this design. Edges in different racks are configured with different VLAN transport zones as they do not share peering VLAN segments.

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/edge_vm_wiring.png)

## BGP Peering and failure domains
Edge VMs are associated with two separate NSX failure domains based on the rack where they are deployed. This configuration is not relevant to the Active/Active Ter-0 gateway deployed by Terraform. If A/S stateful Tier-1 Gateways are deployed on the edge cluster, the placement of the active and standby SRs will be influenced by the failure domain configuration. The result is that no Active and Standby pair is deployed on edges in the same rack. 
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/peering.png)

##How to deploy the topology
1 [Install Terraform on your workstation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2 Clone the repository
```
 git clone https://github.com/vmware-nsx/terraform_edge_topologies/
```
3 Navigate to this folder
```
cd terraform_edge_topologies/4pnic_hosts_2vSphereClusters/
```
4 Open the variable.tf file and edit the variable values based on your environment
```
vi variables.tf
```
The file defaults look like this:
```
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
     edge01_left_ip = "192.168.254.1/24"
     edge02_left_ip = "192.168.254.2/24"
     edge03_left_ip = "192.168.254.4/24"
     edge04_left_ip = "192.168.254.5/24"
     edge01_right_ip = "192.168.253.1/24"
     edge02_right_ip = "192.168.253.2/24"
     edge03_right_ip = "192.168.253.4/24"
     edge04_right_ip = "192.168.253.5/24"
     tor_left_ip    = "192.168.254.3"
     tor_right_ip    = "192.168.253.3"
     tor_left_as     = "65100"
     tor_right_as    = "65100"
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
     password   = "VMware1!VMware1!"
     form_factor = "MEDIUM"
     enable_ssh = "true"
     allow_ssh_root_login = "true"
     uplink_mtu = "9000"
     global_gateway_mtu = "8800"
     bgp_as = "65002"
   }
}
```
5 Initialize Terraform
```
terraform init
```
6 Start the deployment
```
terraform apply
```


