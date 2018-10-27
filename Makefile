# -*- coding: utf-8; mode: make; -*-

SHELL = bash

.PHONY: all
all: lint create

.PHONY: is-defined-%
is-defined-%:
	@$(if $(value $*),,$(error The environment variable $* is undefined))

.PHONY: init
init: is-defined-DIGITALOCEAN_TOKEN is-defined-STARTERKIT_DOMAIN is-defined-STARTERKIT_DROPLET_SSH_PUBKEY
	@terraform init								\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .

.PHONY: upgrade
upgrade: is-defined-DIGITALOCEAN_TOKEN is-defined-STARTERKIT_DOMAIN is-defined-STARTERKIT_DROPLET_SSH_PUBKEY
	@terraform init								\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    -upgrade								\
	    .

.PHONY: lint
lint: init
	@terraform validate							\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .

.PHONY: create
create: lint
	@terraform plan -out=terraform.plan					\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .
	@bash --init-file .helpers.sh -i -c 'unless_yes "Apply this plan?"'
	@terraform apply terraform.plan

.PHONY: destroy
destroy: lint
	@terraform destroy							\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .

.PHONY: format
format:
	@terraform fmt

.PHONY: show-outputs
show-outputs:
	@terraform refresh							\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .
	@terraform output -module=starterkit-mirror

.sshrc: is-defined-STARTERKIT_DROPLET_IP_ADDR
	@echo -en							       "\
	  Host *							     \\n\
	    LogLevel quiet						     \\n\
	    StrictHostKeyChecking no					     \\n\
	    UserKnownHostsFile /dev/null				     \\n\
	  Host starterkit-droplet					     \\n\
	    HostName $(STARTERKIT_DROPLET_IP_ADDR)			     \\n\
	    User core							     \\n\
	" > $@

.PHONY: ssh-add-keys
ssh-add-keys: is-defined-STARTERKIT_DROPLET_SSH_PRIVKEY
	@for SSH_PRIVKEY in "$$STARTERKIT_DROPLET_SSH_PRIVKEY";			\
	do									\
	  echo "$$SSH_PRIVKEY" | grep . - | ssh-add - > /dev/null 2>&1;		\
	done

.PHONY: ssh-%
ssh-%: .sshrc ssh-add-keys
	@ssh -F .sshrc starterkit-$*
