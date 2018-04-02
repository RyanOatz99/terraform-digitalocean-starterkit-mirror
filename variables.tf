# -*- coding: utf-8; mode: terraform -*-

variable "starterkit_domain" {
  # This must not have a default.
}

variable "starterkit_ssh_pubkey" {
  # This must not have a default.
}

variable "starterkit_droplet" {
  default = {
    image  = "coreos-stable"
    name   = "starterkit"
    region = "ams3"
    size   = "s-1vcpu-1gb"
  }
}
