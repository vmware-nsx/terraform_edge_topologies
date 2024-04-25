# ---------------------------------------------------------------------- #
#  Providers
# ---------------------------------------------------------------------- #

terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
      version = "~> 3.6.0"
    }
    vsphere = {
      source = "hashicorp/vsphere"
      version = "~> 2.6.1"
    }
  }
}

provider "nsxt" {
  host                 = var.nsx["fqdn"]
  username             = var.nsx["username"]
  password             = var.nsx["password"]
  on_demand_connection = true
  max_retries          = 10
  retry_min_delay      = 1000
  retry_max_delay      = 8000
  allow_unverified_ssl = true
}


provider "vsphere" {
  user                 = var.vcenter["username"]
  password             = var.vcenter["password"]
  vsphere_server       = var.vcenter["ip"]
  allow_unverified_ssl = true
  api_timeout          = 20
}



# ---------------------------------------------------------------------- #
#  vSphere Data Sources
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
#  Cluster 1


data "vsphere_datacenter" "datacenter" {
  name     = var.vcenter["dc"]
}


data "vsphere_compute_cluster" "cluster1" {
  name          = var.vsphere_edge_cluster1["name"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "cluster1_host1" {
  name          = var.vsphere_edge_cluster1["host1"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "cluster1_host2" {
  name          = var.vsphere_edge_cluster1["host2"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "cluster1_datastore" {
  name          =  var.vsphere_edge_cluster1["datastore"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_distributed_virtual_switch" "cluster1_vds" {
  name          =  var.vsphere_edge_cluster1["vds"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "cluster1_mgmt" {
  name          =  var.vsphere_edge_cluster1["mgmt_dvpg"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# ---------------------------------------------------------------------- #
#  Cluster 2

data "vsphere_compute_cluster" "cluster2" {
  name          = var.vsphere_edge_cluster2["name"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "cluster2_host1" {
  name          = var.vsphere_edge_cluster2["host1"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_host" "cluster2_host2" {
  name          = var.vsphere_edge_cluster2["host2"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "cluster2_datastore" {
  name          =  var.vsphere_edge_cluster2["datastore"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_distributed_virtual_switch" "cluster2_vds" {
  name          =  var.vsphere_edge_cluster2["vds"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "cluster2_mgmt" {
  name          =  var.vsphere_edge_cluster2["mgmt_dvpg"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


# ---------------------------------------------------------------------- #
#  Create Edge uplink dvpgs cluster 1
# ---------------------------------------------------------------------- #


resource "vsphere_distributed_port_group" "cluster1_left_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-left-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 1"]
  standby_uplinks = ["Uplink 2"]
}

resource "vsphere_distributed_port_group" "cluster1_left_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-left-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 3"]
  standby_uplinks = ["Uplink 4"]
}

resource "vsphere_distributed_port_group" "cluster1_right_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-right-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 2"]
  standby_uplinks = ["Uplink 1"]
}

resource "vsphere_distributed_port_group" "cluster1_right_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-right-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 4"]
  standby_uplinks = ["Uplink 3"]
}


# ---------------------------------------------------------------------- #
#  Create Edge uplink dvpgs cluster 2
# ---------------------------------------------------------------------- #


resource "vsphere_distributed_port_group" "cluster2_left_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-left-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 1"]
  standby_uplinks = ["Uplink 2"]
}

resource "vsphere_distributed_port_group" "cluster2_left_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-left-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 3"]
  standby_uplinks = ["Uplink 4"]
}

resource "vsphere_distributed_port_group" "cluster2_right_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-right-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 2"]
  standby_uplinks = ["Uplink 1"]
}

resource "vsphere_distributed_port_group" "cluster2_right_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-right-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_range {
    min_vlan = 0
    max_vlan = 4094
  }
  active_uplinks  = ["Uplink 4"]
  standby_uplinks = ["Uplink 3"]
}


# ----------------------------------------------- #
#  Edge TEP IP Pool Cluster 1
# ----------------------------------------------- #
resource "nsxt_policy_ip_pool" "cluster1_tep_ip_pool" {
  display_name = "${data.vsphere_compute_cluster.cluster1.name}-edge-tep-pool"
}

data "nsxt_policy_realization_info" "cluster1_tep_ip_pool" {
  path = nsxt_policy_ip_pool.cluster1_tep_ip_pool.path
}

resource "nsxt_policy_ip_pool_static_subnet" "cluster1_tep_ip_pool_range" {
  display_name = "range 1"
  pool_path    = nsxt_policy_ip_pool.cluster1_tep_ip_pool.path
  cidr         = var.vsphere_edge_cluster1.edge_tep_cidr
  gateway      = var.vsphere_edge_cluster1.edge_tep_gateway

  allocation_range {
    start = var.vsphere_edge_cluster1.edge_tep_start
    end   = var.vsphere_edge_cluster1.edge_tep_end
  }
}


# ----------------------------------------------- #
#  Edge TEP IP Pool Cluster 2
# ----------------------------------------------- #
resource "nsxt_policy_ip_pool" "cluster2_tep_ip_pool" {
  display_name = "${data.vsphere_compute_cluster.cluster2.name}-edge-tep-pool"
}

data "nsxt_policy_realization_info" "cluster2_tep_ip_pool" {
  path = nsxt_policy_ip_pool.cluster2_tep_ip_pool.path
}

resource "nsxt_policy_ip_pool_static_subnet" "cluster2_tep_ip_pool_range" {
  display_name = "range 1"
  pool_path    = nsxt_policy_ip_pool.cluster2_tep_ip_pool.path
  cidr         = var.vsphere_edge_cluster2.edge_tep_cidr
  gateway      = var.vsphere_edge_cluster2.edge_tep_gateway

  allocation_range {
    start = var.vsphere_edge_cluster2.edge_tep_start
    end   = var.vsphere_edge_cluster2.edge_tep_end
  }
}





# ----------------------------------------------- #
#  Uplink Profiles
# ----------------------------------------------- #

resource "nsxt_policy_uplink_host_switch_profile" "edge_uplink_profile_cluster1" {
  display_name = "edge_uplink_profile_${data.vsphere_compute_cluster.cluster1.name}"

  transport_vlan = var.vsphere_edge_cluster1.edge_tep_vlan_id
  overlay_encap  = "GENEVE"

  teaming {
    active {
      uplink_name = "uplink1"
      uplink_type = "PNIC"
    }
    active {
      uplink_name = "uplink2"
      uplink_type = "PNIC"
    }
    policy = "LOADBALANCE_SRCID"
  }

  named_teaming {
    active {
      uplink_name = "uplink1"
      uplink_type = "PNIC"
    }
    policy = "FAILOVER_ORDER"
    name   = "uplink_1_only"
  }

  named_teaming {
    active {
      uplink_name = "uplink2"
      uplink_type = "PNIC"
    }
    policy = "FAILOVER_ORDER"
    name   = "uplink_2_only"
  }
}

resource "nsxt_policy_uplink_host_switch_profile" "edge_uplink_profile_cluster2" {
  display_name = "edge_uplink_profile_${data.vsphere_compute_cluster.cluster2.name}"

  transport_vlan = var.vsphere_edge_cluster2.edge_tep_vlan_id
  overlay_encap  = "GENEVE"

  teaming {
    active {
      uplink_name = "uplink1"
      uplink_type = "PNIC"
    }
    active {
      uplink_name = "uplink2"
      uplink_type = "PNIC"
    }
    policy = "LOADBALANCE_SRCID"
  }

  named_teaming {
    active {
      uplink_name = "uplink1"
      uplink_type = "PNIC"
    }
    policy = "FAILOVER_ORDER"
    name   = "uplink_1_only"
  }

  named_teaming {
    active {
      uplink_name = "uplink2"
      uplink_type = "PNIC"
    }
    policy = "FAILOVER_ORDER"
    name   = "uplink_2_only"
  }
}


# ----------------------------------------------- #
#  Transport Zones
# ----------------------------------------------- #

data "nsxt_policy_transport_zone" "overlay_transport_zone" {
  display_name = "nsx-overlay-transportzone"
}

resource "nsxt_policy_transport_zone" "vlan_transport_zone_edge" {
  display_name   = "nsx-vlan-edge-transportzone"
  transport_type = "VLAN_BACKED"
  uplink_teaming_policy_names = ["uplink_1_only" , "uplink_2_only" ]
}

# ----------------------------------------------- #
#  Compute Manager
# ----------------------------------------------- #

data "nsxt_compute_manager" "vcenter" {
  display_name = var.vcenter.compute_manager_name
}

# ---------------------------------------------------------------------- #
#  Create Edges in cluster 1 connected to Uplink1 and Uplink2
# ---------------------------------------------------------------------- #


resource "nsxt_edge_transport_node" "cluster1_edgenode1" {
  description  = "${data.vsphere_compute_cluster.cluster1.name} Edge node 1"
  display_name = "${data.vsphere_compute_cluster.cluster1.name}-edge-node1"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster1_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster1.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster1_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster1_left_uplink1and2.id, vsphere_distributed_port_group.cluster1_right_uplink1and2.id]
      compute_id            = data.vsphere_compute_cluster.cluster1.id
      storage_id            = data.vsphere_datastore.cluster1_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster1["edge01_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster1["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster1["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster1.name}-edge-node1"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}

resource "nsxt_edge_transport_node" "cluster1_edgenode2" {
  description  = "${data.vsphere_compute_cluster.cluster1.name} Edge node 2"
  display_name = "${data.vsphere_compute_cluster.cluster1.name}-edge-node2"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster1_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster1.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster1_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster1_left_uplink1and2.id, vsphere_distributed_port_group.cluster1_right_uplink1and2.id]
      compute_id            = data.vsphere_compute_cluster.cluster1.id
      storage_id            = data.vsphere_datastore.cluster1_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster1["edge02_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster1["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster1["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster1.name}-edge-node2"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}



# ---------------------------------------------------------------------- #
#  Create Edges in cluster 1 connected to Uplink3 and Uplink4
# ---------------------------------------------------------------------- #


resource "nsxt_edge_transport_node" "cluster1_edgenode3" {
  description  = "${data.vsphere_compute_cluster.cluster1.name} Edge node 3"
  display_name = "${data.vsphere_compute_cluster.cluster1.name}-edge-node3"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster1_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster1.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster1_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster1_left_uplink3and4.id, vsphere_distributed_port_group.cluster1_right_uplink3and4.id]
      compute_id            = data.vsphere_compute_cluster.cluster1.id
      storage_id            = data.vsphere_datastore.cluster1_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster1["edge03_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster1["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster1["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster1.name}-edge-node3"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}


resource "nsxt_edge_transport_node" "cluster1_edgenode4" {
  description  = "${data.vsphere_compute_cluster.cluster1.name} Edge node 4"
  display_name = "${data.vsphere_compute_cluster.cluster1.name}-edge-node4"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster1_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster1.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster1_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster1_left_uplink3and4.id, vsphere_distributed_port_group.cluster1_right_uplink3and4.id]
      compute_id            = data.vsphere_compute_cluster.cluster1.id
      storage_id            = data.vsphere_datastore.cluster1_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster1["edge04_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster1["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster1["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster1.name}-edge-node4"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}


# ---------------------------------------------------------------------- #
#  Create Edges in cluster 2 connected to Uplink1 and Uplink2
# ---------------------------------------------------------------------- #


resource "nsxt_edge_transport_node" "cluster2_edgenode1" {
  description  = "${data.vsphere_compute_cluster.cluster2.name} Edge node 1"
  display_name = "${data.vsphere_compute_cluster.cluster2.name}-edge-node1"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster2_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster2.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster2_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster2_left_uplink1and2.id, vsphere_distributed_port_group.cluster2_right_uplink1and2.id]
      compute_id            = data.vsphere_compute_cluster.cluster2.id
      storage_id            = data.vsphere_datastore.cluster2_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster2["edge01_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster2["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster2["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster2.name}-edge-node1"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}

resource "nsxt_edge_transport_node" "cluster2_edgenode2" {
  description  = "${data.vsphere_compute_cluster.cluster2.name} Edge node 2"
  display_name = "${data.vsphere_compute_cluster.cluster2.name}-edge-node2"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster2_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster2.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster2_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster2_left_uplink1and2.id, vsphere_distributed_port_group.cluster2_right_uplink1and2.id]
      compute_id            = data.vsphere_compute_cluster.cluster2.id
      storage_id            = data.vsphere_datastore.cluster2_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster2["edge02_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster2["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster2["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster2.name}-edge-node2"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}


# ---------------------------------------------------------------------- #
#  Create Edges in cluster 2 connected to Uplink3 and Uplink4
# ---------------------------------------------------------------------- #


resource "nsxt_edge_transport_node" "cluster2_edgenode3" {
  description  = "${data.vsphere_compute_cluster.cluster2.name} Edge node 3"
  display_name = "${data.vsphere_compute_cluster.cluster2.name}-edge-node3"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster2_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster2.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster2_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster2_left_uplink3and4.id, vsphere_distributed_port_group.cluster2_right_uplink3and4.id]
      compute_id            = data.vsphere_compute_cluster.cluster2.id
      storage_id            = data.vsphere_datastore.cluster2_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster2["edge03_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster2["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster2["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster2.name}-edge-node3"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}

resource "nsxt_edge_transport_node" "cluster2_edgenode4" {
  description  = "${data.vsphere_compute_cluster.cluster2.name} Edge node 4"
  display_name = "${data.vsphere_compute_cluster.cluster2.name}-edge-node4"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.cluster2_tep_ip_pool.realized_id
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_transport_zone.id
    }
    transport_zone_endpoint {
      transport_zone = nsxt_policy_transport_zone.vlan_transport_zone_edge.realized_id
    }
    host_switch_profile = [nsxt_policy_uplink_host_switch_profile.edge_uplink_profile_cluster2.realized_id]
    pnic {
      device_name = "fp-eth0"
      uplink_name = "uplink1"
    }
    pnic {
      device_name = "fp-eth1"
      uplink_name = "uplink2"
    }
  }
  deployment_config {
    form_factor = var.edge_nodes["form_factor"]
    node_user_settings {
      cli_password  = var.edge_nodes["password"]
      root_password = var.edge_nodes["password"]
    }
    vm_deployment_config {
      management_network_id = data.vsphere_network.cluster2_mgmt.id
      data_network_ids      = [ vsphere_distributed_port_group.cluster2_left_uplink3and4.id, vsphere_distributed_port_group.cluster2_right_uplink3and4.id]
      compute_id            = data.vsphere_compute_cluster.cluster2.id
      storage_id            = data.vsphere_datastore.cluster2_datastore.id
      vc_id                 = data.nsxt_compute_manager.vcenter.id
      management_port_subnet {
        ip_addresses  = [var.vsphere_edge_cluster2["edge04_mgmt_ip"]]
        prefix_length = var.vsphere_edge_cluster2["edge_mgmt_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster2["edge_mgmt_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "${data.vsphere_compute_cluster.cluster2.name}-edge-node4"
    allow_ssh_root_login = var.edge_nodes["allow_ssh_root_login"]
    enable_ssh           = var.edge_nodes["enable_ssh"]
  }
}


# ---------------------------------------------------------------------- #
#  Create Edge Cluster
# ---------------------------------------------------------------------- #


data "nsxt_transport_node_realization" "cluster1_edgenode1_realization" {
  id      = nsxt_edge_transport_node.cluster1_edgenode1.id
  timeout = 3000
}

data "nsxt_transport_node_realization" "cluster1_edgenode3_realization" {
  id      = nsxt_edge_transport_node.cluster1_edgenode3.id
  timeout = 3000
}

data "nsxt_transport_node_realization" "cluster2_edgenode1_realization" {
  id      = nsxt_edge_transport_node.cluster2_edgenode1.id
  timeout = 3000
}

data "nsxt_transport_node_realization" "cluster2_edgenode3_realization" {
  id      = nsxt_edge_transport_node.cluster2_edgenode3.id
  timeout = 3000
}


data "nsxt_transport_node_realization" "cluster1_edgenode2_realization" {
  id      = nsxt_edge_transport_node.cluster1_edgenode2.id
  timeout = 3000
}

data "nsxt_transport_node_realization" "cluster1_edgenode4_realization" {
  id      = nsxt_edge_transport_node.cluster1_edgenode4.id
  timeout = 3000
}

data "nsxt_transport_node_realization" "cluster2_edgenode2_realization" {
  id      = nsxt_edge_transport_node.cluster2_edgenode2.id
  timeout = 3000
}

data "nsxt_transport_node_realization" "cluster2_edgenode4_realization" {
  id      = nsxt_edge_transport_node.cluster2_edgenode4.id
  timeout = 3000
}



resource "nsxt_edge_cluster" "edgecluster1" {
  display_name = "Edge-cluster"
  member {
    transport_node_id = nsxt_edge_transport_node.cluster1_edgenode1.id
  }
   member {
    transport_node_id = nsxt_edge_transport_node.cluster1_edgenode3.id
  }
   member {
    transport_node_id = nsxt_edge_transport_node.cluster2_edgenode1.id
  }
   member {
    transport_node_id = nsxt_edge_transport_node.cluster2_edgenode3.id
  }
    member {
    transport_node_id = nsxt_edge_transport_node.cluster1_edgenode2.id
  }
   member {
    transport_node_id = nsxt_edge_transport_node.cluster1_edgenode4.id
  }
   member {
    transport_node_id = nsxt_edge_transport_node.cluster2_edgenode2.id
  }
   member {
    transport_node_id = nsxt_edge_transport_node.cluster2_edgenode4.id
  }
  depends_on         = [data.nsxt_transport_node_realization.cluster1_edgenode1_realization,data.nsxt_transport_node_realization.cluster1_edgenode3_realization,data.nsxt_transport_node_realization.cluster2_edgenode1_realization,data.nsxt_transport_node_realization.cluster2_edgenode3_realization,data.nsxt_transport_node_realization.cluster1_edgenode2_realization,data.nsxt_transport_node_realization.cluster1_edgenode4_realization,data.nsxt_transport_node_realization.cluster2_edgenode2_realization,data.nsxt_transport_node_realization.cluster2_edgenode4_realization]
}


# ---------------------------------------------------------------------- #
#  Create DRS Rules for Edges
# ---------------------------------------------------------------------- #

resource "vsphere_compute_cluster_host_group" "cluster1_host1" {
  name               = "EdgeHost1inEdgeCluster1"
  compute_cluster_id = data.vsphere_compute_cluster.cluster1.id
  host_system_ids    = [data.vsphere_host.cluster1_host1.id]
}

resource "vsphere_compute_cluster_host_group" "cluster1_host2" {
  name               = "EdgeHost2inEdgeCluster1"
  compute_cluster_id = data.vsphere_compute_cluster.cluster1.id
  host_system_ids    = [data.vsphere_host.cluster1_host2.id]
}

resource "vsphere_compute_cluster_host_group" "cluster2_host1" {
  name               = "EdgeHost1inEdgeCluster2"
  compute_cluster_id = data.vsphere_compute_cluster.cluster2.id
  host_system_ids    = [data.vsphere_host.cluster2_host1.id]
}

resource "vsphere_compute_cluster_host_group" "cluster2_host2" {
  name               = "EdgeHost2inEdgeCluster2"
  compute_cluster_id = data.vsphere_compute_cluster.cluster2.id
  host_system_ids    = [data.vsphere_host.cluster2_host2.id]
}

data "vsphere_virtual_machine" "cluster1_edge1" {
  name          = nsxt_edge_transport_node.cluster1_edgenode1.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster1_edgenode1_realization]
}

data "vsphere_virtual_machine" "cluster1_edge2" {
  name          = nsxt_edge_transport_node.cluster1_edgenode2.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster1_edgenode2_realization]
}

data "vsphere_virtual_machine" "cluster1_edge3" {
  name          = nsxt_edge_transport_node.cluster1_edgenode3.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster1_edgenode3_realization]
}

data "vsphere_virtual_machine" "cluster1_edge4" {
  name          = nsxt_edge_transport_node.cluster1_edgenode4.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster1_edgenode4_realization]
}

data "vsphere_virtual_machine" "cluster2_edge1" {
  name          = nsxt_edge_transport_node.cluster2_edgenode1.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster2_edgenode1_realization]
}

data "vsphere_virtual_machine" "cluster2_edge2" {
  name          = nsxt_edge_transport_node.cluster2_edgenode2.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster2_edgenode2_realization]
}

data "vsphere_virtual_machine" "cluster2_edge3" {
  name          = nsxt_edge_transport_node.cluster2_edgenode3.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster2_edgenode3_realization]
}

data "vsphere_virtual_machine" "cluster2_edge4" {
  name          = nsxt_edge_transport_node.cluster2_edgenode4.display_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
  depends_on         = [data.nsxt_transport_node_realization.cluster2_edgenode4_realization]
}

resource "vsphere_compute_cluster_vm_group" "cluster1_host1" {
  name                = "Cluster1_EdgeHost1"
  compute_cluster_id  = data.vsphere_compute_cluster.cluster1.id
  virtual_machine_ids = [data.vsphere_virtual_machine.cluster1_edge1.id,data.vsphere_virtual_machine.cluster1_edge3.id]
}

resource "vsphere_compute_cluster_vm_group" "cluster1_host2" {
  name                = "Cluster1_EdgeHost2"
  compute_cluster_id  = data.vsphere_compute_cluster.cluster1.id
  virtual_machine_ids = [data.vsphere_virtual_machine.cluster1_edge2.id,data.vsphere_virtual_machine.cluster1_edge4.id]
}

resource "vsphere_compute_cluster_vm_group" "cluster2_host1" {
  name                = "Cluster2_EdgeHost1"
  compute_cluster_id  = data.vsphere_compute_cluster.cluster2.id
  virtual_machine_ids = [data.vsphere_virtual_machine.cluster2_edge1.id,data.vsphere_virtual_machine.cluster2_edge3.id]
}

resource "vsphere_compute_cluster_vm_group" "cluster2_host2" {
  name                = "Cluster2_EdgeHost2"
  compute_cluster_id  = data.vsphere_compute_cluster.cluster2.id
  virtual_machine_ids = [data.vsphere_virtual_machine.cluster2_edge2.id,data.vsphere_virtual_machine.cluster2_edge4.id]
}


resource "vsphere_compute_cluster_vm_host_rule" "cluster1_host1" {
  compute_cluster_id       = data.vsphere_compute_cluster.cluster1.id
  name                     = "Edge Host 1 Edge nodes 1 and 3"
  vm_group_name            = "${vsphere_compute_cluster_vm_group.cluster1_host1.name}"
  affinity_host_group_name = "${vsphere_compute_cluster_host_group.cluster1_host1.name}"
}

resource "vsphere_compute_cluster_vm_host_rule" "cluster1_host2" {
  compute_cluster_id       = data.vsphere_compute_cluster.cluster1.id
  name                     = "Edge Host 2 Edge nodes 2 and 4"
  vm_group_name            = "${vsphere_compute_cluster_vm_group.cluster1_host2.name}"
  affinity_host_group_name = "${vsphere_compute_cluster_host_group.cluster1_host2.name}"
}

resource "vsphere_compute_cluster_vm_host_rule" "cluster2_host1" {
  compute_cluster_id       = data.vsphere_compute_cluster.cluster1.id
  name                     = "Edge Host 1 Edge nodes 1 and 3"
  vm_group_name            = "${vsphere_compute_cluster_vm_group.cluster2_host1.name}"
  affinity_host_group_name = "${vsphere_compute_cluster_host_group.cluster2_host1.name}"
}

resource "vsphere_compute_cluster_vm_host_rule" "cluster2_host2" {
  compute_cluster_id       = data.vsphere_compute_cluster.cluster1.id
  name                     = "Edge Host 2 Edge nodes 2 and 4"
  vm_group_name            = "${vsphere_compute_cluster_vm_group.cluster2_host2.name}"
  affinity_host_group_name = "${vsphere_compute_cluster_host_group.cluster2_host2.name}"
}


