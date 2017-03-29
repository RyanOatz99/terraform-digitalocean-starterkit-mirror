# -*- coding: utf-8; mode: terraform -*-

resource "digitalocean_droplet" "starterkit_droplet" {
  image    = "${var.starterkit_droplet["image"]}"
  name     = "${var.starterkit_droplet["name"]}"
  region   = "${var.starterkit_droplet["region"]}"
  size     = "${var.starterkit_droplet["size"]}"
  ssh_keys = ["${digitalocean_ssh_key.starterkit_ssh_pubkey.id}"]
}
