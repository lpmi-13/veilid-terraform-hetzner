# Veilid Terraform Hetzner

Details at https://veilid.com/

Run a veilid node on Hetzner cloud. Hetzner doesn't have a free tier, but it's very cheap (approx $5/month), and should be pretty easy.

## Setup

1. If you don't already have one, get an account with [Hetzner](https://www.hetzner.com/cloud/).

2. Depending on whether the system thinks your account is a high risk one, you may need to submit ID documents for verification (this is fairly quick, and can be something like a picture of your drivers license. If you already have an account set up, you probably won't need to worry about this step.

3. Once you're set up and verified, create a new project (there should be a big button to create a new project when you navigate to https://console.hetzner.cloud).

4. In the project menu, click on API tokens, and create a new one. Make sure to give it Read/Write access.

5. Copy `.env.example` to `.env` and add the API token into that file. Then run `source .env` to set the API token in your shell.

6. Add in the value for your SSH key (if you want to be able to access the node) in `setup-veilid.yaml`.

> If you want to use a separate SSH key, then generate one in this folder like ssh-keygen -t ed25519 -o -a 100 -f veilid-key. Then, make sure to update setup-veilid.yaml with the key contents.

7. Now you're ready to run `terraform init && terraform apply`.

The public IP addresses you can connect to should be shown in the output after the command runs:

```sh
Outputs:

public_ipv4 = [
  "37.27.84.176",
]
public_ipv6 = [
  "2a01:4f9:c012:4a3c::1",
]
```

And you should be able to connect via:

```sh
ssh -i PATH_TO_PRIVATE_SSH_KEY veilid@IP_ADDRESS_FROM_OUTPUT
```

> If, like me, your ISP doesn't give you an IPV6 address, then you'll have to make do with connecting via the IPV4 address.
