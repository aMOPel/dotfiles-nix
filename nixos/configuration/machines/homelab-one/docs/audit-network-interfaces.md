# auditing network interfaces

auditing the exposed network interfaces:

- https (tls)
- smb
- ssh

## general

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

## https (tls)

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

## smb

### nmap

nmap scripts

```sh
nix-shell -p nmap --run "nmap --script 'smb*' -p445 homelab-one"
```

### smbclient

verify connection

```sh
nix-shell -p samba --run "smbclient //homelab-one/public -U $USER -c ls"
```

## ssh

### nmap

common problems

```sh
nix-shell -p nmap --run "nmap --script 'ssh*' -p22 homelab-one"
```

### ssh-audit

ensure only save algorithms are used by sshd

```sh
nix-shell -p ssh-audit --run "ssh-audit homelab-one"
```
