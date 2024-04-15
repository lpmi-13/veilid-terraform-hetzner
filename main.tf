terraform {
  required_version = ">= 1.5.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.45"
    }
  }
}

locals {
  node_count = 1
  datacenter = "hel1-dc2" # Helsinki, Finland
  # nbg1-dc3 # Nuremberg, Germany
  # fsn1-dc14 # Falkenstein, Germany
  # hil-dc1 # Hillsboro, Oregon
  # ash-dc1 # Ashburn, Virginia
}

resource "hcloud_server" "veilid-node" {
  count       = local.node_count
  name        = "veilid-node-${count.index}"
  image       = "ubuntu-22.04"
  server_type = "cax11"
  datacenter  = local.datacenter

  keep_disk = false

  user_data = base64encode(file("./setup-veilid.yaml"))

  public_net {
    # If your ISP is fancy and gives you an IPV6 address, then you can turn off this IPV4 allocation
    # It will save you about 0.60 EUR/month
    # ...you can also turn it off if you just want to leave the node running for a while. The veilid
    # server will happily use the IPV6 address to communicate with the network.
    ipv4_enabled = true
    ipv6_enabled = true
  }
}