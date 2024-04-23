# Veilid Terraform Hetzner

Details at https://veilid.com/

Run a veilid node on Hetzner cloud. Hetzner doesn't have a free tier, but it's very cheap (approx $5/month), and should be pretty easy.

## Cost

Because Hetzner charges for IPv4 addresses, the default configuration here doesn't use one. This saves about $0.75/month. It's set up to run via IPv6, though if you need to access the nodes via an IPv4 ssh connection, see the instructions below.

## Setup

1. If you don't already have one, get an account with [Hetzner](https://www.hetzner.com/cloud/).

2. Depending on whether the system thinks your account is a high risk one, you may need to submit ID documents for verification (this is fairly quick, and can be something like a picture of your drivers license. If you already have an account set up, you probably won't need to worry about this step.

3. Once you're set up and verified, create a new project (there should be a big button to create a new project when you navigate to https://console.hetzner.cloud).

4. In the project menu, click on API tokens, and create a new one. Make sure to give it Read/Write access.

5. Copy `.env.example` to `.env` and add the API token into that file. Then run `source .env` to set the API token in your shell.

6. Add in the value for your SSH key (if you want to be able to access the node) in `setup-veilid.yaml`. If you don't care about SSH access, just skip this step.

> If you want to use a separate SSH key, then generate one in this folder like ssh-keygen -t ed25519 -o -a 100 -f veilid-key. Then, make sure to update setup-veilid.yaml with the key contents.

7. Now you're ready to run `terraform init && terraform apply`.

The public IP address you can connect to should be shown in the output after the command runs:

```sh
Outputs:

public_ipv4 = [
  "",
]
public_ipv6 = [
  "2a01:4f9:c012:4a3c::1",
]
```

## Connecting

And you should then be able to connect via:

```sh
ssh -i PATH_TO_PRIVATE_SSH_KEY veilid@IP_ADDRESS_FROM_OUTPUT
```

> Depending on your system, you might need to include square brackets around the IP address if using IPv6 to connect, eg - `ssh -i PATH_TO_PRIVATE_SSH_KEY veilid@[IP_ADDRESS_FROM_OUTPUT]`

If you don't have an IPv6 address from your ISP and you want to connect via IPv4, then change the value for `ipv4_enabled = false` to `ipv4_enabled = true` in `main.tf`. Run `terraform apply`, and you should see the appropriate IP address in the output:

```sh
Outputs:

public_ipv4 = [
  "37.27.84.176",
]
public_ipv6 = [
  "2a01:4f9:c012:4a3c::1",
]
```

There's a current open [bug](https://github.com/hetznercloud/terraform-provider-hcloud/issues/688) relating to needing to run `terraform apply` twice to see the IP addresses picked up in the output, so just re-run the command if that happens.