# -*- coding: utf-8; mode: terraform; -*-

provider "digitalocean" {
  # https://www.terraform.io/docs/providers/do/index.html
  version = "~> 0.1"
}

resource "digitalocean_ssh_key" "starterkit_ssh_pubkey" {
  name       = "starterkit"
  public_key = "${var.starterkit_ssh_pubkey}"
}
