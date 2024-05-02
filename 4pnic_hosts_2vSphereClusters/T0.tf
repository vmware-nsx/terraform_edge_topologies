
data "nsxt_policy_edge_cluster" "edgecluster1" {
  display_name = "Edge-cluster"
  depends_on         = [nsxt_edge_cluster.edgecluster1]
}

data "nsxt_policy_edge_node" "cluster1_edgenode1" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster1_edgenode1.display_name
}

data "nsxt_policy_edge_node" "cluster1_edgenode2" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster1_edgenode2.display_name
}

data "nsxt_policy_edge_node" "cluster1_edgenode3" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster1_edgenode3.display_name
}

data "nsxt_policy_edge_node" "cluster1_edgenode4" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster1_edgenode4.display_name
}

data "nsxt_policy_edge_node" "cluster2_edgenode1" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster2_edgenode1.display_name
}

data "nsxt_policy_edge_node" "cluster2_edgenode2" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster2_edgenode2.display_name
}

data "nsxt_policy_edge_node" "cluster2_edgenode3" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster2_edgenode3.display_name
}

data "nsxt_policy_edge_node" "cluster2_edgenode4" {
  edge_cluster_path = data.nsxt_policy_edge_cluster.edgecluster1.path
  display_name = nsxt_edge_transport_node.cluster2_edgenode4.display_name
}

resource "nsxt_policy_tier0_gateway" "t0-gateway" {
  description              = "T0 provisioned by Terraform"
  display_name             = "t0-gateway"
  nsx_id                   = "t0-gateway"
  failover_mode            = "PREEMPTIVE"
  default_rule_logging     = false
  enable_firewall          = var.edge_nodes.enable_t0_firewall
  ha_mode                  = "ACTIVE_ACTIVE"
  edge_cluster_path        = data.nsxt_policy_edge_cluster.edgecluster1.path

  bgp_config {
    local_as_num    = var.edge_nodes.bgp_as
    multipath_relax = false
  }
}



resource "nsxt_policy_segment" "t0-gateway-left-cluster1" {
  display_name        = "left-uplink-${data.vsphere_compute_cluster.cluster1.name}"
  transport_zone_path = nsxt_policy_transport_zone.vlan_transport_zone_edge_cluster01.path
  vlan_ids = [var.vsphere_edge_cluster1.left_uplink_vlan]
  advanced_config {
    uplink_teaming_policy = "uplink_1_only"
  }
}

resource "nsxt_policy_segment" "t0-gateway-right-cluster1" {
  display_name        = "right-uplink-${data.vsphere_compute_cluster.cluster1.name}"
  transport_zone_path = nsxt_policy_transport_zone.vlan_transport_zone_edge_cluster01.path
  vlan_ids = [var.vsphere_edge_cluster1.right_uplink_vlan]
  advanced_config {
    uplink_teaming_policy = "uplink_1_only"
  }
}


resource "nsxt_policy_segment" "t0-gateway-left-cluster2" {
  display_name        = "left-uplink-${data.vsphere_compute_cluster.cluster2.name}"
  transport_zone_path = nsxt_policy_transport_zone.vlan_transport_zone_edge_cluster02.path
  vlan_ids = [var.vsphere_edge_cluster2.left_uplink_vlan]
  advanced_config {
    uplink_teaming_policy = "uplink_1_only"
  }
}

resource "nsxt_policy_segment" "t0-gateway-right-cluster2" {
  display_name        = "right-uplink-${data.vsphere_compute_cluster.cluster2.name}"
  transport_zone_path = nsxt_policy_transport_zone.vlan_transport_zone_edge_cluster02.path
  vlan_ids = [var.vsphere_edge_cluster2.right_uplink_vlan]
  advanced_config {
    uplink_teaming_policy = "uplink_1_only"
  }
}

# ----------------------------------------------- #
#  External Interfaces - vSphere Cluster 1 - Left
# ----------------------------------------------- #


resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge1-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge01-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode1.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge01_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}


resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge2-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge02-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode2.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge02_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge3-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge03-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode3.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge03_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge4-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge04-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode4.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge04_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}



# ----------------------------------------------- #
#  External Interfaces - vSphere Cluster 1 - Right
# ----------------------------------------------- #


resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge1-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge01-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode1.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge01_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}


resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge2-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge02-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode2.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge02_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge3-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge03-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode3.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge03_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster1-edge4-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster1.name}-edge04-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster1_edgenode4.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster1.path
  subnets        = [var.vsphere_edge_cluster1.edge04_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

# ----------------------------------------------- #
#  External Interfaces - vSphere Cluster 2 - Left
# ----------------------------------------------- #


resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge1-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge01-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode1.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge01_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge2-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge02-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode2.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge02_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge3-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge03-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode3.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge03_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge4-left" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge04-left"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode4.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-left-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge04_left_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

# ----------------------------------------------- #
#  External Interfaces - vSphere Cluster 2 - Right
# ----------------------------------------------- #

resource  "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge1-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge01-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode1.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge01_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}


resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge2-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge02-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode2.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge02_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge3-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge03-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode3.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge03_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}

resource "nsxt_policy_tier0_gateway_interface" "uplink-cluster2-edge4-right" {
  display_name   = "${data.vsphere_compute_cluster.cluster2.name}-edge04-right"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.cluster2_edgenode4.path
  gateway_path   = nsxt_policy_tier0_gateway.t0-gateway.path
  segment_path   = nsxt_policy_segment.t0-gateway-right-cluster2.path
  subnets        = [var.vsphere_edge_cluster2.edge04_right_ip]
  mtu            = var.edge_nodes.uplink_mtu
  urpf_mode      = var.edge_nodes.t0_urpf_mode
}


# ----------------------------------------------- #
#  BGP Configuration
# ----------------------------------------------- #

resource "nsxt_policy_bgp_neighbor" "bgp-nei-cluster1-left" {
  display_name          = "Cluster1 Left ToR"
  bgp_path              = nsxt_policy_tier0_gateway.t0-gateway.bgp_config.0.path
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = 12
  keep_alive_time       = 3
  neighbor_address      = var.vsphere_edge_cluster1.tor_left_ip
  remote_as_num         = var.vsphere_edge_cluster1.tor_left_as
  route_filtering {
     address_family   = "IPV4"
  }
}

resource "nsxt_policy_bgp_neighbor" "bgp-nei-cluster1-right" {
  display_name          = "Cluster1 right ToR"
  bgp_path              = nsxt_policy_tier0_gateway.t0-gateway.bgp_config.0.path
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = 12
  keep_alive_time       = 3
  neighbor_address      = var.vsphere_edge_cluster1.tor_right_ip
  remote_as_num         = var.vsphere_edge_cluster1.tor_right_as
  route_filtering {
     address_family   = "IPV4"
  }
}


resource "nsxt_policy_bgp_neighbor" "bgp-nei-cluster2-left" {
  display_name          = "cluster2 Left ToR"
  bgp_path              = nsxt_policy_tier0_gateway.t0-gateway.bgp_config.0.path
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = 12
  keep_alive_time       = 3
  neighbor_address      = var.vsphere_edge_cluster2.tor_left_ip
  remote_as_num         = var.vsphere_edge_cluster2.tor_left_as
  route_filtering {
     address_family   = "IPV4"
  }
}

resource "nsxt_policy_bgp_neighbor" "bgp-nei-cluster2-right" {
  display_name          = "cluster2 right ToR"
  bgp_path              = nsxt_policy_tier0_gateway.t0-gateway.bgp_config.0.path
  graceful_restart_mode = "HELPER_ONLY"
  hold_down_time        = 12
  keep_alive_time       = 3
  neighbor_address      = var.vsphere_edge_cluster2.tor_right_ip
  remote_as_num         = var.vsphere_edge_cluster2.tor_right_as
  route_filtering {
     address_family   = "IPV4"
  }
}

resource "nsxt_policy_gateway_redistribution_config" "t0-gateway-redistribution" {
  gateway_path = nsxt_policy_tier0_gateway.t0-gateway.path
  bgp_enabled  = true

  rule {
    name  = "rule-1"
    types = ["TIER0_STATIC", "TIER0_CONNECTED", "TIER0_EXTERNAL_INTERFACE", "TIER0_SEGMENT", "TIER0_ROUTER_LINK", "TIER0_SERVICE_INTERFACE", "TIER0_LOOPBACK_INTERFACE", "TIER0_DNS_FORWARDER_IP", "TIER0_IPSEC_LOCAL_IP", "TIER0_NAT", "TIER0_EVPN_TEP_IP", "TIER1_NAT", "TIER1_STATIC", "TIER1_LB_VIP", "TIER1_LB_SNAT", "TIER1_DNS_FORWARDER_IP", "TIER1_CONNECTED", "TIER1_SERVICE_INTERFACE", "TIER1_SEGMENT", "TIER1_IPSEC_LOCAL_ENDPOINT" ]
  }
}
