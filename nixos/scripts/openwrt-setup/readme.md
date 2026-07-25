## iot network

- from 2.4ghz wifi radio, create separate iot network
- create separate "iot_lan" interface with `protocol: static address` with
  `device: iot wifi` on `ipv4: 192.168.2.1/24`
- create firewall zone "iot_lan" and `lan => iot_lan forward`,
  `iot_lan => wan forward`, `input: accept; output: accept; intra_zone: reject;`

## tls cert for webui

0. install deps on openwrt (with webui)

   ```
   luci-app-uhttpd
   openssl-util
   ```

1. generate the cert and key in this repo

   ```sh
   nix-shell -p openssl sops step-cli --run "./nixos/scripts/openwrt-setup/tls-cert.sh"
   ```

2. copy the cert and key over to the openwrt router

   ```sh
   scp -O ./temp/openwrt.crt root@openwrt.lan:/etc/ssl/certs/openwrt.crt
   scp -O ./temp/openwrt.key root@openwrt.lan:/etc/ssl/certs/openwrt.key
   rm ./temp
   ```

3. pick the cert and key in webui

   ```
   Services -> uhttpd -> general settings -> https certificate
   Services -> uhttpd -> general settings -> https private key
   Save and apply
   ```

4. restart uhttpd on openwrt router

   ```sh
   ssh root@openwrt.lan

   service uhttpd restart
   ```

## adguardhome setup

<https://openwrt.org/docs/guide-user/services/dns/adguard-home>

## tls cert for adguardhome

```sh
cp /etc/ssl/certs/openwrt.key /etc/ssl/certs/adguardhome.key
cp /etc/ssl/certs/openwrt.crt /etc/ssl/certs/adguardhome.crt
chown adguardhome:adguardhome /etc/ssl/certs/adguardhome.key
chown adguardhome:adguardhome /etc/ssl/certs/adguardhome.crt
vi /etc/adguardhome/adguardhome.yaml
# tls:
#   port_https: 8080
#   enabled: true
#   force_https: true
#   certificate_path: /etc/ssl/certs/adguardhome.crt
#   private_key_path: /etc/ssl/certs/adguardhome.key
service adguardhome restart
```
