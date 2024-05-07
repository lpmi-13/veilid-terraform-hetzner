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
  # this is a bit of a hack, since if you don't set an SSH key here, Hetzner will send you an email
  # with a root login password on server creation, even though we set an SSH key in the cloud-init
  # script.
  ssh_keys = [hcloud_ssh_key.veilid-key.id]

  user_data = base64encode(file("./setup-veilid.yaml"))

  public_net {
    # set this to "true" to configure an IPv4 address if you need that for SSH access.
    ipv4_enabled = false
    ipv6_enabled = true
  }

  firewall_ids = [hcloud_firewall.veilid-firewall.id]
}

resource "hcloud_firewall" "veilid-firewall" {
  name = "veilid"
  rule {
    description = "this is for SSH access"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "5150"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "udp"
    port      = "5150"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

# same part of the hack (see note above). You can either generate this key locally following the
# steps in the README, or point it to another key on your system.
resource "hcloud_ssh_key" "veilid-key" {
  name       = "veilid-key"
  public_key = file("PATH_TO_SSH_KEY")
}
