output "public_ipv4" {
  value = [
    for node in hcloud_server.veilid-node : node.ipv4_address
  ]
}

output "public_ipv6" {
  value = [
    for node in hcloud_server.veilid-node : node.ipv6_address
  ]
}
