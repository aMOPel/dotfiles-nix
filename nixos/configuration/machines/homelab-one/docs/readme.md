## users, groups, file structure

- each service has its own user and group.
- files and directories belonging to a service are owned by that service (this
  improves security, "least privilege")
- important data should live in `/snapraid/mergerfs`, since only that mount is
  protected by RAID

## samba

### after new setup

- on server, set samba password for default user
  ```sh
  ./nixos/scripts/new-install-server/7-init-samba.sh
  ```
- after that, log into samba share

```
WORKGROUP: WORKGROUP
HOSTNAME: homelab-one
SHARE: public
USER: default user
```

```sh
nix-shell -p samba --run "smbclient //homelab-one/public -U $USER -c ls"
```

## radicale

- caldav and carddav server
- users are handled in `secrets/radicale-users.yaml`, to edit:
  ```sh
  nix-shell -p sops --run "sops edit secrets/authelia-users.yaml"
  ```
  - to generate new entry:
  ```sh
  nix-shell -p apacheHttpd --run "htpasswd -n $USER"
  ```

## secrets

- managed with [sops-nix](https://github.com/Mic92/sops-nix)

- about sops
  - `.sops.yaml` defines which asymmetric keypairs can be used for encryption of
    which files
  - `secrets/` contains the sops secrets
  - manually view/edit sops secrets with
    ```sh
    nix-shell -p sops --run "sops edit secrets/$FILE_NAME.yaml"
    ```

- about sops-nix
  - uses sops
  - needs minimal setup in `configuration.nix` to point to the
    `sops.age.keyFile`
  - this
    ```nix
    {
      sops.secrets."root-ca/public-cert" =
        owner = "step-ca";
        sopsFile = ./secrets/step-ca.yaml;
    }
    ```
    makes the secret in the file `./secrets/step-ca.yaml` at the key
    `.root-ca.public-cert` available as the file
    `/run/secrets/root-ca/public-cert`, and gives only the owner permissions to
    the file
  - this happens early in the build process, so that other modules can depend on
    the secrets

### after new setup

1. generate new key on server
   ```nix
   sops.age.generateKey = true;
   ```
   or
   ```sh
   nix-shell -p age --run "./nixos/scripts/new-install-server/5-generate-age-key.sh"
   ```
2. insert the new public key into [.sops.yaml](https://github.com/getsops/sops)
   and reencrypt secrets
   ```sh
   nix-shell -p sops --run "./nixos/scripts/new-install-server/5-other-machine-update-age-key.sh"
   ```

### threat model

- age key from `homelab-one` in `/root/.config/sops/age/keys.txt`, rw only by
  root `600 root:root`, this is generally considered safe enough, since access
  to this equals complete compromise of the whole system, i.e. root access),
  can't use passphrase, since sops-nix doesn't support it for remote deploy
- TODO: research TPM, NixOS Impermanence

## https/acme

- acme client and server both run on `homelab-one`
  - step-ca as "acme server"
  - nixos acme module as "acme client"
  - nginx reverse proxy configured to use acme (client)

- explanation for ca files:
  ```
  root-ca: root public/private key pair, the idea is that if this is never leaked, clients don't have to trust a new cert, if the intermediate ca is leaked
      public-cert: every client needs to trust this cert, all other certs are
      private-password: used to decrypt private key
      private-key: should be kept offline at all times
  intermediate-ca: cert chain from the root key, kept on the server, used directly by step-ca for acme protocol
      public-cert: clients don't need to trust this cert, just the root-cert
      private-password: used to decrypt private key
      private-key: step-ca needs access to this
      public-key:
  ```

### issues

- sometimes the acme service will not fetch the certs from step-ca due to a race
  condition and instead rather serve a selfsigned cert to nginx. a restart of
  the respective acme service does the trick:
  ```sh
  systemctl restart acme-prometheus.homelab-one.lan.service
  ```

### after new setup

- ca is generated with:
  ```sh
  nix-shell -p step-cli -p yq-go -p sops -p openssl --run \
      "SOPS_DIR=./secrets \
      SOPS_FILE=./step-ca.yaml \
      CA_OUTDIR=./nixos/configuration/machines/homelab-one/certificates \
      ./nixos/scripts/new-install-server/6-init-step-ca.sh"
  ```
  - this generates all necessary keys and certs and puts all those in a `.yaml`
    file and encrypt it with sops (all sensitive information is cleaned up
    afterward, but does exist on the filesystem briefly)

### key rotation

- manual process
- intermediate-ca needs rotation every 1y
- root-ca needs rotation every 10y
- to rotate both root and intermediate-ca, do same as initial generation
- to rotate just the intermediate-ca, use `ROTATE_INTERMEDIATE=true`
  ```sh
  nix-shell -p step-cli -p yq-go -p sops -p openssl --run \
      "SOPS_DIR=./secrets \
      SOPS_FILE=./step-ca.yaml \
      CA_OUTDIR=./nixos/configuration/machines/homelab-one/certificates \
      ROTATE_INTERMEDIATE=true \
      ./nixos/scripts/new-install-server/6-init-step-ca.sh"
  ```

### threat model

- age key on server is only readable as root
- intermediate-ca private key is only readable as step-ca user or as root
- root-ca is never on server, but is encrypted in public github repo
- if server is accessed as root, the complete ca including root is compromised
  client trust does not need to be updated

- TODO: it would be safer to keep the root-ca offline, then on server
  compromise, only intermediate-ca has to be rotated, client trust would not
  need to be updated
  - but this would make intermediate-ca rotation more complicated, since the
    offline root-ca would need to be accessed for rotation

### client certificates

- on android
  1. copy `.der` cert to android device
  2. install cert
  ```
  Settings > Security & Privacy > Encryption & Credentials >
  Install a certificate > CA certificate > choose the file
  ```
- on nixos
  ```nix
  {
    security.pki.certificateFiles = [
      path-to/root-ca.crt
    ]
  }
  ```

## subdomains and dns

- to gain service domain isolation and its security benefits, we use nginx to
  reverse proxy subdomains per service (e.g. resolve "radicale.homelab-one" to
  same ip address as "homelab-one")
- to do that name resolution dnsmasq is used
- test dns setup with
  ```sh
  nix-shell -p dig --run "dig @<dns ip> <domain to resolve>"
  ```

### after new setup

- register homelab lan ip address as
  `connectivity > local network > "static DNS 1"` in the lan router, so other
  devices in the lan can resolve the subdomains (**warning**: this means, all
  intra-lan dns traffic will be routed from the router to the selfhosted dnsmasq
  instance, only be routed back again)

## ldap

- serves as source of truth for user accounts
- used by various services like authelia
- db admin password and user accounts are manually managed with
  ```sh
  nix-shell -p sops --run "sops edit ./secrets/ldap-users.yaml"
  ```

### after new setup

- service accounts are generated with
  ```sh
  nix-shell -p sops -p yq-go --run \
      'OUTDIR=./temp \
      SOPS_DIR=./secrets \
      SOPS_FILE=ldap-service-users.yaml \
      ./nixos/scripts/new-install-server/10-init-ldap-service-users.sh'
  ```

## authelia

- authentication layer for services
- uses ldap as source for truth for user accounts
- is oidc provider for services if possible
- otherwise used in "Forwarded Authentication" mode, where nginx is configured
  to redirect to authelia if a session cookie is missing
- **IMPORTANT** services are not protected by default, their nginx config needs
  to be adapted to be protected

### after new setup

- regenerate secrets
  ```sh
  nix-shell -p sops -p yq-go --run \
      "OUTDIR=./temp \
      SOPS_DIR=./secrets \
      SOPS_FILE=authelia.yaml \
      ./nixos/scripts/new-install-server/9-init-authelia.sh"
  ```

## grafana

- uses ldap as source for truth for user accounts

## forgejo

- protected by authelia

### after new setup

- regenerate secrets
  ```sh
  nix-shell -p sops -p yq-go --run \
    "OUTDIR=./temp \
    SOPS_DIR=./secrets \
    SOPS_FILE=forgejo.yaml \
    ./nixos/scripts/new-install-server/8-init-forgejo.sh"
  ```

## disk formatting/partitions/filesystem

TODO:

## service isolation

TODO:

### network isolation

TODO:
