# -*- coding: utf-8; mode: make; -*-

SHELL = bash

.PHONY: .sshrc all check-variables-defined create destroy format init is-defined-% lint show-outputs ssh-% ssh-add-keys upgrade

all: lint create

is-defined-%:
	@$(if $(value $*),,$(error The environment variable $* is undefined))

check-variables-defined: is-defined-DIGITALOCEAN_TOKEN is-defined-STARTERKIT_DOMAIN is-defined-STARTERKIT_DROPLET_SSH_PUBKEY

init: check-variables-defined
	@terraform init

upgrade: check-variables-defined
	@terraform init -upgrade

create: lint
	@terraform plan -out=terraform.plan					\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .
	@bash --init-file .helpers.sh -i -c 'unless_yes "Apply this plan?"'
	@terraform apply terraform.plan

destroy: lint
	@terraform destroy							\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .

format:
	@terraform fmt

lint: init
	@terraform validate							\
	    -var=digitalocean_token="$(DIGITALOCEAN_TOKEN)"			\
	    -var=starterkit_domain="$(STARTERKIT_DOMAIN)"			\
	    -var=starterkit_ssh_pubkey="$(STARTERKIT_DROPLET_SSH_PUBKEY)"	\
	    .

show-outputs:
	@terraform output

.sshrc: is-defined-STARTERKIT_DROPLET_IP_ADDR
	@echo -en							       "\
	  Host *							     \\n\
	    LogLevel quiet						     \\n\
	    StrictHostKeyChecking no					     \\n\
	    UserKnownHostsFile /dev/null				     \\n\
	  Host starterkit-droplet					     \\n\
	    HostName $(STARTERKIT_DROPLET_IP_ADDR)			     \\n\
	    User core					      		     \\n\
	" > $@

ssh-add-keys: is-defined-STARTERKIT_DROPLET_SSH_PRIVKEY
	@for SSH_PRIVKEY in "$$STARTERKIT_DROPLET_SSH_PRIVKEY";			\
	do									\
	  echo "$$SSH_PRIVKEY" | grep . - | ssh-add - > /dev/null 2>&1;		\
	done

ssh-%: .sshrc ssh-add-keys
	@ssh -F .sshrc starterkit-$*
