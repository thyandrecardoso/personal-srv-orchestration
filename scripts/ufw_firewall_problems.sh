#!/usr/bin/env bash

# docker daemon messes with iptables for its own operation.
# this process is not transparent from the outside :S
# https://www.jeffgeerling.com/blog/2020/be-careful-docker-might-be-exposing-ports-world
# https://github.com/chaifeng/ufw-docker#solving-ufw-and-docker-issues
# https://github.com/docker/for-linux/issues/690
#
# To cope with this, we install a script that allows us to correctly open ports for containers from the host.
# - https://github.com/chaifeng/ufw-docker#ufw-docker-util

apt-get install -y ufw
ufw allow ssh
ufw enable

sudo wget -O /usr/local/bin/ufw-docker \
  https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
chmod +x /usr/local/bin/ufw-docker
ufw-docker install
ufw-docker allow custom-nginx-proxy 80/tcp
ufw-docker allow custom-nginx-proxy 443/tcp
ufw-docker allow nfs 2049/tcp
