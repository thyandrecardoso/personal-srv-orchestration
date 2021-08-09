#!/bin/sh

# taken from https://github.com/piwi3910/techtalk/issues/6

sleep 120

ip link add macvlan-link link bond0 type macvlan mode bridge
ip addr add <synology-ip>/32 dev macvlan-link
ip link set macvlan-link up
ip route add <container-ip>/32 dev macvlan-link
