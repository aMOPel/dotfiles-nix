#!/usr/bin/env bash

FILE_NAME=/var/lib/radicale/users

sudo htpasswd -5 -c "$FILE_NAME" "$USER"
sudo chmod 600 "$FILE_NAME"
sudo chown radicale:radicale "$FILE_NAME"
