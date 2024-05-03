# L3 Aware Edge Design for VCF
## Rack Layout

This folder includes the Terraform files to deploy NSX edge nodes in the following topology:
* Rack separated by L3 boundary in the physical fabric
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
sds
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/edge_vm_wiring.png)
wdwdw
![alt text](https://github.com/vmware-nsx/terraform_edge_topologies/blob/main/4pnic_hosts_2vSphereClusters/assets/peering.png)



