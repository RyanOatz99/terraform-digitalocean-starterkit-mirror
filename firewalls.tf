# -*- coding: utf-8; mode: terraform -*-

resource "digitalocean_firewall" "starterkit_firewall" {
  name = "allow-outbound-ssh-http-https"

  droplet_ids = [
    "${digitalocean_droplet.starterkit_droplet.id}",
  ]

  inbound_rule = [
    {
      protocol   = "tcp"
      port_range = "22"

      source_addresses = [
        "0.0.0.0/0",
        "::/0",
      ]
    },
    {
      protocol   = "tcp"
      port_range = "80"

      source_addresses = [
        "0.0.0.0/0",
        "::/0",
      ]
    },
    {
      protocol   = "tcp"
      port_range = "443"

      source_addresses = [
        "0.0.0.0/0",
        "::/0",
      ]
    },
  ]

  outbound_rule = [
    {
      protocol   = "tcp"
      port_range = "all"

      destination_addresses = [
        "0.0.0.0/0",
        "::/0",
      ]
    },
    {
      protocol   = "udp"
      port_range = "53"  # DNS

      destination_addresses = [
        "0.0.0.0/0",
        "::/0",
      ]
    },
  ]
}
