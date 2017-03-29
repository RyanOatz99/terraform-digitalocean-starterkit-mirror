[![build status](https://gitlab.com/tvaughan/terraform-digitalocean-starterkit/badges/master/build.svg)](https://gitlab.com/tvaughan/terraform-digitalocean-starterkit/commits/master)

Terraform DigitalOcean Starterkit
===

Quick Start
---

* Purchase a domain name somewhere and set its name servers to:
  ns1.digitalocean.com, ns2.digitalocean.com, and ns3.digitalocean.com.

* Install [Terraform](https://www.terraform.io/downloads.html).

* Edit [variables.tf](variables.tf) as necessary.

* Create an SSH key pair. Run:

        ssh-keygen -C starterkit -f starterkit -t ed25519

  This creates a private key, `starterkit`, and a public key,
  `starterkit.pub`. **DO NOT** commit `starterkit` or `starterkit.pub` to this
  repository.

* Go to https://cloud.digitalocean.com/settings/api/tokens and create a
  personal access token.

* Set some environment variables. For example:

        DIGITALOCEAN_TOKEN="ff...42"
        STARTERKIT_DOMAIN="example.mil"
        STARTERKIT_DROPLET_SSH_PUBKEY="ssh-ed25519 AA...zz starterkit"

* `make`

    Carefully review the plan. Press `Y` to apply the plan or `Enter` to not.

* `make ssh-droplet`

    This step is optional. Some additional environment variables are
    required. For example:

        "
        STARTERKIT_DROPLET_IP_ADDR=$(terraform output starterkit_droplet_public_ip_address)
        STARTERKIT_DROPLET_SSH_PRIVKEY="
        -----BEGIN OPENSSH PRIVATE KEY-----
        Pk2vQbZhFeA85CA3gGYyEwhfHqyzkZ+RDE2dycyBdKSotAvIuuinfG84KyW1bjVKjSGIjLOy/d9u
        P7zIjR1qWaMNQ8ALEnMLRXJ0uxz+UFp3GBfrASO/g+bkWs3Q8XbpFKVM94gC4t8VU0+uJf0vVbQv
        ...
        -----END OPENSSH PRIVATE KEY-----
        "

What?
---

A DigitalOcean droplet is created. This droplet is accessible by anyone via
the internet. Please take the appropriate steps to secure this droplet against
unintended access.

DNS entries will be created for `www.$STARTERKIT_DOMAIN` and
`$STARTERKIT_DOMAIN` that point to the droplet.

See Also
---

* https://gitlab.com/tvaughan/docker-flask-starterkit
