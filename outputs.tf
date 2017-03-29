# -*- coding: utf-8; mode: terraform; -*-

output "starterkit_droplet_public_ip_address" {
  value = "${digitalocean_droplet.starterkit_droplet.ipv4_address}"
}
