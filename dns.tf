# -*- coding: utf-8; mode: terraform -*-

resource "digitalocean_domain" "starterkit_domain" {
  ip_address = "${digitalocean_droplet.starterkit_droplet.ipv4_address}"
  name       = "${var.starterkit_domain}"
}

resource "digitalocean_record" "starterkit_record_www" {
  domain = "${digitalocean_domain.starterkit_domain.name}"
  name   = "www"
  type   = "CNAME"
  value  = "@"
}
