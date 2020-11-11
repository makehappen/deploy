#!/usr/bin/env bash

# call script with
# SERVER_IP=... && . src/server/get-ssh-key.sh

ssh ubuntu@$SERVER_IP "cat ~/.ssh/id_rsa.pub"
