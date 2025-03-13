#!/usr/bin/env bash

yum update -y
yum install -y jq
echo "Bastion host setup complete" > /var/log/bastion_setup.logs