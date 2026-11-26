#!/bin/bash
set -e

echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-nat.conf
sysctl --system

INTERFACE=$(ip route show default | awk '{print $5; exit}')

iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o "$INTERFACE" -j MASQUERADE

iptables -A FORWARD -s 10.0.2.0/24 -j ACCEPT

iptables -A FORWARD -d 10.0.2.0/24 \
    -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

apt-get -o Acquire::Retries=5 update
DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent

netfilter-persistent save
