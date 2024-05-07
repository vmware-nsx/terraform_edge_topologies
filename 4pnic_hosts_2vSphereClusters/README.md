# L3 Aware Edge Design for VCF
## Rack Layout

This folder includes the Terraform files to deploy NSX edge nodes in the following topology:
* Rack separated by L3 boundary in the physical fabric, no VLAN/subnet shared across racks.
* Two Independent vSphere clusters dedicated to NSX edges, one per rack. This design choice increases the NSX Edges' availability.
* Minimum of 3 hosts per vSphere cluster if using vSAN, 2 if using NFS
* 4 pNIC hosts
* 1 VDS per cluster, single VDS controlling all 4 pNICs
* 2 edge nodes per host (Large or XL edge VM form factor recommended), 4 total per vSphere cluster, placed deterministically on a specific host via DRS should rules
* Single Tier-0 Gateway A/A Stateless spanning all 8 edge nodes across the two racks/vSphere cluster
* Tier-1 gateways are not deployed as part of the deployment. They can be  added after the deployment is complete. The tier-1 gateways can be added manually or programmatically via additional Terraform files or other automation solutions (i.e., Aria Automation, vClud Director, Tanzu Supervisor cluster)
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/Rack_layout.png?raw=true)


## VDS Configuration
VDSs (One per cluster) are created by the SDDC manager cluster creation workflow. An edge management dvpg must be created manually before using Terraform to deploy the edges. All other VDS configurations and dvpg creation are automated via Terraform. The objects created by Terraform are presented in blue in the diagram, and in purple/violet those that must be present in advance.
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/VDS_Layout.png?raw=true)

## NSX Edge host switch configuration 
Edge nodes are deployed following the model presented by the VCF and NSX Design guides. Only two data path interfaces are in use, both managed by the same host switch (AKA NVDS). The two data path interfaces are shared by the VLAN uplinks to the physical network and by the two TEP interfaces for overlay traffic. Please refer to the [NSX Design guide, chapter 7](https://nsx.techzone.vmware.com/resource/nsx-reference-design-guide#nsx-design-considerations) for more insight into this design. Edges in different racks are configured with different VLAN transport zones as they do not share peering VLAN segments.

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/Edge_Vm_Wiring.png)

## BGP Peering and failure domains
Edge VMs are associated with two separate NSX failure domains based on the rack where they are deployed. This configuration is not relevant to the Active/Active Ter-0 gateway deployed by Terraform. If A/S stateful Tier-1 Gateways are deployed on the edge cluster, the placement of the active and standby SRs will be influenced by the failure domain configuration. The result is that no Active and Standby pair is deployed on edges in the same rack. 
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/peering.png)

## How to deploy the topology
1. [Install Terraform on your workstation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Clone the repository
```
 git clone https://github.com/vmware-nsx/terraform_edge_topologies/
```
3. Navigate to this folder
```
cd terraform_edge_topologies/4pnic_hosts_2vSphereClusters/
```
4. Open the variable.tf file and edit the variable values based on your environment
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
     password   = "VMware1!VMware1!" #Edge nodes' initial password
     form_factor = "MEDIUM" # Edge nodes form factor
     enable_t0_firewall = "false" #Do you need stateless firewall on the T0? If not set to false
     t0_urpf_mode = "NONE" #STRICT or NONE 
     enable_ssh = "true"
     allow_ssh_root_login = "true"
     uplink_mtu = "9000" # Should match the MTU of the peering SVIs on the ToRs
     bgp_as = "65002" # BGP AS of the NSX T0 Gateway
   }
}
```
5. Initialize Terraform
```
terraform init
```
6. Start the deployment
```
terraform apply
```

## Screenshot from a deployment using the default values of the variable file
This section has screenshots from a lab environment deployed without changing the value of the variables in the variables.tf file. It should help identify where those values are applied, for example, the variables referring to the IPs used for the management interfaces and the uplinks of the edge nodes.

### VDS distributed-port-groups
The Terraform deployment creates 4 trunk dvpgs on each VDS, two for each pair of uplinks, 1 and 2, and 3 and 4. Each dvpg is configured with an active/standby explicit failover teaming policy as described in the VDS diagram layout above. The management dvpg for the NSX Edge VMs must be pre-created on each VDS and referenced in the variables.tf file.

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/dvpgs.png)

### Edge VMs (8):

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/Edge_VMS.png)

### Edge to host DRS Rules:

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/DRS_Rules.png)

### Edge uplink profiles
One per rack (or vSphere cluster). Identical except for the Edge TEP VLAN:

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/edge_uplink_profile_cluster1.png)

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/edge_uplink_profile_cluster2.png)

### Edge uplinks VLAN segments(4)
Not shown in the screenshot but they use, in order, VLAN 100, 300, 200, and 400. The left segments use the teaming policy "uplink_1_only", and the right segments "uplink_2_only". The teaming policies have been added to the two edge VLAN transport zones.

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/uplink_vlan_segments.png)

### T0 Uplink interfaces (16)

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/T0_uplinks.png)

### BGP Peers (4)

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/BGP_PEERs.png)

### BGP Configuration

![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/BGP_Config.png)
