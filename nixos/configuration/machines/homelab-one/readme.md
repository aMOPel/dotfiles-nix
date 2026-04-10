## users, groups, file structure

- each service has its own user and group.
- files and directories belonging to a service are owned by that service (this
  improves security, "least privilege")
- web services serve their files from `/srv/*`
- files can be hardlinked from `/home/$USERNAME/*` to `/srv/*`
  - TODO: is this good?

## samba

### after new setup

- on server, set samba password for default user
  ```sh
  ./nixos/scripts/new-install/5-init-samba.sh
  ```
- after that, default user can log into samba share

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
   ```sh
   nix-shell -p age --run "./nixos/scripts/new-install/7-generate-age-key.sh"
   ```
2. edit [.sops.yaml](https://github.com/getsops/sops) and add the new age public
   key to the list
3. reencrypt secrets
   ```sh
   nix-shell -p sops --run "sops updatekeys secrets/*.yaml"
   ```

- TODO: maybe use builtin age key generation from sops-nix
- TODO: or improve script to automate all 3 steps

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

### after new setup

- ca is generated with:
  ```sh
  nix-shell -p step-cli -p yq-go -p sops --run \
      "SOPS_DIR=./secrets SOPS_FILE=./step-ca.yaml CA_OUTDIR=./ca ./nixos/scripts/new-install/6-init-step-ca.sh"
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
  nix-shell -p step-cli -p yq-go -p sops --run \
      "SOPS_DIR=./secrets SOPS_FILE=./step-ca.yaml CA_OUTDIR=./ca ROTATE_INTERMEDIATE=true ./nixos/scripts/new-install/6-init-step-ca.sh"
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
  1. convert PEM cert to DER cert
  ```sh
  nix-shell -p openssl --run "openssl x509 -in ./nixos/configuration/machines/homelab-one/certificates/root-ca.crt -outform der -out cert.der"
  ```
  2. copy cert to android device
  3. install cert
  ```
  Settings > Security & Privacy > Encryption & Credentials >
  Install a certificate > CA certificate > choose the file
  ```
- on nixos
  ```nix
  {
    security.pki.certificateFiles = [
      path-to-cert
    ]
  }
  ```

## hardening

### tls

test tls config

```sh
nix-shell -p testssl --run "testssl.sh --add-ca ./nixos/configuration/machines/homelab-one/certificates/root-ca.crt https://homelab-one"
```

complains about:

- ```
  Certificate Validity (UTC)   expires < 30 days (0) (2026-04-10 09:30 --> 2026-04-11 09:31)
  OCSP URI                     --
                                NOT ok -- neither CRL nor OCSP URI provided
  ```
  but step-ca does not support ocsp, because it uses shortlived certs instead of
  active revocationg [see docs](https://smallstep.com/docs/step-ca/revocation/)

- ```
  DNS CAA RR (experimental)    not offered
  ```
  dns caa rr is beyond my scope.

### nginx

test nginx config

#### builtin checker

already executed by nixos nginx module

1. get config from nix-store

```sh
systemctl status nginx
```

2. copy line with `-t` and run it with sudo

```sh
sudo /nix/store/...-nginx-1.28.0/bin/nginx -t -c /nix/store/...-nginx.conf
```

#### gixy

test nginx config:

1. get config from nix-store

```sh
systemctl status nginx
```

2. run gixy with that config

```
nix-shell -p gixy --run "gixy $CONFIG"
```

### nmap

scan open ports

```sh
nix-shell -p nmap --run "nmap homelab-one"
```

### nikto

general server test

```sh
nix-shell -p nikto --run "nikto -host homelab-one -ssl"
```
