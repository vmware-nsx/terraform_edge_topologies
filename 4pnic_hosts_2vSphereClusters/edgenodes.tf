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
  vlan_id = var.vsphere_edge_cluster1.left_uplink_vlan
  active_uplinks  = ["Uplink 1"]
  standby_uplinks = ["Uplink 2"]
}

resource "vsphere_distributed_port_group" "cluster1_left_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-left-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_id = var.vsphere_edge_cluster1.left_uplink_vlan
  active_uplinks  = ["Uplink 3"]
  standby_uplinks = ["Uplink 4"]
}

resource "vsphere_distributed_port_group" "cluster1_right_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-right-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_id = var.vsphere_edge_cluster1.right_uplink_vlan
  active_uplinks  = ["Uplink 2"]
  standby_uplinks = ["Uplink 1"]
}

resource "vsphere_distributed_port_group" "cluster1_right_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster1_vds.name}-edge-right-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster1_vds.id
  vlan_id = var.vsphere_edge_cluster1.right_uplink_vlan
  active_uplinks  = ["Uplink 4"]
  standby_uplinks = ["Uplink 3"]
}


# ---------------------------------------------------------------------- #
#  Create Edge uplink dvpgs cluster 2
# ---------------------------------------------------------------------- #


resource "vsphere_distributed_port_group" "cluster2_left_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-left-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_id = var.vsphere_edge_cluster2.left_uplink_vlan
  active_uplinks  = ["Uplink 1"]
  standby_uplinks = ["Uplink 2"]
}

resource "vsphere_distributed_port_group" "cluster2_left_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-left-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_id = var.vsphere_edge_cluster2.left_uplink_vlan
  active_uplinks  = ["Uplink 3"]
  standby_uplinks = ["Uplink 4"]
}

resource "vsphere_distributed_port_group" "cluster2_right_uplink1and2" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-right-uplink1and2"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_id = var.vsphere_edge_cluster2.right_uplink_vlan
  active_uplinks  = ["Uplink 2"]
  standby_uplinks = ["Uplink 1"]
}

resource "vsphere_distributed_port_group" "cluster2_right_uplink3and4" {
  name                            = "${data.vsphere_distributed_virtual_switch.cluster2_vds.name}-edge-right-uplink3and4"
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.cluster2_vds.id
  vlan_id = var.vsphere_edge_cluster2.right_uplink_vlan
  active_uplinks  = ["Uplink 4"]
  standby_uplinks = ["Uplink 3"]
}


# ----------------------------------------------- #
#  IP Pool
# ----------------------------------------------- #
resource "nsxt_policy_ip_pool" "tep_ip_pool" {
  display_name = "TEP_POOL"
}

data "nsxt_policy_realization_info" "tep_ip_pool" {
  path = nsxt_policy_ip_pool.tep_ip_pool.path
}

resource "nsxt_policy_ip_pool_static_subnet" "tep_ip_pool_range" {
  display_name = "range1"
  pool_path    = nsxt_policy_ip_pool.tep_ip_pool.path
  cidr         = "192.168.130.0/24"
  gateway      = "192.168.130.1"

  allocation_range {
    start = "192.168.130.2"
    end   = "192.168.130.254"
  }
}

# ----------------------------------------------- #
#  Uplink Profiles
# ----------------------------------------------- #

resource "nsxt_policy_uplink_host_switch_profile" "edge_uplink_profile_cluster1" {
  display_name = "edge_uplink_profile_${data.vsphere_compute_cluster.cluster1.name}"

  transport_vlan = var.vsphere_edge_cluster1.tep_vlan_id
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

  transport_vlan = var.vsphere_edge_cluster2.tep_vlan_id
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


resource "nsxt_edge_transport_node" "edgenode1" {
  description  = "Edge node 1"
  display_name = "edge-node1"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.tep_ip_pool.realized_id
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
        ip_addresses  = [var.vsphere_edge_cluster1["edge01_ip"]]
        prefix_length = var.vsphere_edge_cluster1["edge_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster1["edge_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "edge-node1"
    allow_ssh_root_login = true
    enable_ssh           = true
  }
}


# ---------------------------------------------------------------------- #
#  Create Edges in cluster 1 connected to Uplink3 and Uplink4
# ---------------------------------------------------------------------- #


resource "nsxt_edge_transport_node" "edgenode3" {
  description  = "Edge node 3"
  display_name = "edge-node3"
  standard_host_switch {
    ip_assignment {
      static_ip_pool = data.nsxt_policy_realization_info.tep_ip_pool.realized_id
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
        ip_addresses  = [var.vsphere_edge_cluster1["edge03_ip"]]
        prefix_length = var.vsphere_edge_cluster1["edge_prefix_length"]
      }
      default_gateway_address = [var.vsphere_edge_cluster1["edge_gateway_ip"]]
    }
  }
  node_settings {
    hostname             = "edge-node3"
    allow_ssh_root_login = true
    enable_ssh           = true
  }
}
