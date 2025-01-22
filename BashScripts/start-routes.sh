#!/bin/bash


echo "Iniciando..."
# commands
iptables -A FORWARD -o vlan.600 -i eth3 -j ACCEPT
iptables -A FORWARD -i vlan.600 -o eth3 -j ACCEPT

ip r add 172.212.0.0/16 via 10.60.1.208
iptables -t nat -A POSTROUTING -s 172.212.0.0/16 ! -o vlan.600 -j MASQUERADE

ip r add 172.220.0.0/16 via 10.60.1.8
iptables -t nat -A POSTROUTING -s 172.220.0.0/16 ! -o vlan.600 -j MASQUERADE
