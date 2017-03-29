# -*- coding: utf-8; mode: terraform; -*-

provider "do" {
  # https://www.terraform.io/docs/providers/do/index.html
}

resource "digitalocean_ssh_key" "starterkit_ssh_pubkey" {
  name       = "starterkit"
  public_key = "${var.starterkit_ssh_pubkey}"
}
