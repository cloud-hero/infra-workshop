#!/bin/bash -v
curl -L https://bootstrap.saltstack.com | sudo sh -s -- -U -P -X -A REPLACE_SALT_MASTER_IP stable 2016.11
echo -e "app: docker-cluster\nrole: nodejs\nenv: production\nrealm: all\ndocker: worker\nconsul: agent\ndc: aws\nzone: ireland" > /etc/salt/grains
service salt-minion restart
apt remove --purge -y lxd snapd lxcfs lxc-common lxd-client
