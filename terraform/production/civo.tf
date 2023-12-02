# Query xsmall instance size
data "civo_size" "xsmall" {
  filter {
    key = "type"
    values = ["kubernetes"]
  }

  sort {
    key = "ram"
    direction = "asc"
  }
}

# Create a firewall
resource "civo_firewall" "raidingway" {
  name = "raidingway"
}

# Create a firewall rule
resource "civo_firewall_rule" "kubernetes_access" {
  firewall_id = civo_firewall.raidingway.id
  protocol = "tcp"
  start_port = "6443"
  end_port = "6443"
  cidr = ["0.0.0.0/0"]
  direction = "ingress"
  label = "kubernetes-api-server"
  action = "allow"
}

resource "civo_kubernetes_cluster" "raidingway" {
  name = "raidingway"
  firewall_id = civo_firewall.raidingway.id
  cluster_type = "talos"
  cni = "cilium"
  pools {
    size = element(data.civo_size.xsmall.sizes, 0).name
    node_count = 3
  }
}
