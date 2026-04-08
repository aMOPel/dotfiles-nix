## users, groups, file structure

- each service has its own user and group.
- files and directories belonging to a services are owned by that service (this
  improves security, "least privilege")
- web services serve their files from `/srv/*`
- files can be hardlinked from `/home/$USERNAME/*` to `/srv/*`
  - TODO: is this good?

## samba

- after new install, run `./nixos/scripts/new-install/5-init-samba.sh` on server
  to set samba pw
- then default user can log into samba share

## secrets

- managed with [sops-nix](https://github.com/Mic92/sops-nix)
- secrets, which are kept in this repo are managed with sops-nix
  - gpg key from `themachine`
  - age key from `homelab-one`
    - in `/root/.config/sops/age/keys.txt`, rw only by root `600 root:root`,
      (this is generally considered safe enough, since access to the equals
      complete compromise of the whole system, i.e. root access), can't use
      passphrase, since sops-nix doesn't support it for remote deploy
      - TODO: could do better with gpg?
    - for new install, have to generate new key
      ```sh
      sudo -i
      nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"
      chmod 600 ~/.config/sops/age/keys.txt
      chown root:root ~/.config/sops/age/keys.txt
      ```
- to add new host key, e.g. after new install, secrets need to be reencrypted:
  1. edit [.sops.yaml](https://github.com/getsops/sops) to register new key
  2. ```sh
     nix-shell -p sops --run "sops updatekeys secrets/*.yaml"
     ```
- manually view/edit sops secrets with
  ```sh
  nix-shell -p sops --run "sops edit secrets/$FILE_NAME.yaml"
  ```

## https/acme

- acme client and server both run on `homelab-one`
  - step-ca as "acme server"
  - nixos acme module as "acme client"
  - nginx reverse proxy configured to use acme (client)
- ca is generated with:
  ```sh
  nix-shell -p step-cli -p yq-go -p sops --run \
      "SOPS_DIR=./secrets SOPS_FILE=./step-ca.yaml CA_OUTDIR=./ca ./nixos/scripts/new-install/6-init-step-ca.sh"
  ```
  - this generates all necessary keys and certs and puts all those in a `.yaml`
    file and encrypt it with sops (all sensitive information is cleaned up
    afterward, but does exist on the filesystem briefly)
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
- TODO: it would be safer to keep the root-ca offline, but we keep it encrypted
  online here
- to rotate the intermediate-ca, use `ROTATE_INTERMEDIATE=true`
  ```sh
  nix-shell -p step-cli -p yq-go -p sops --run \
      "SOPS_DIR=./secrets SOPS_FILE=./step-ca.yaml CA_OUTDIR=./ca ROTATE_INTERMEDIATE=true ./nixos/scripts/new-install/6-init-step-ca.sh"
  ```
