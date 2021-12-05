#!/bin/bash

DHCP="dhcp"
STATIC="static"

if [ "$(id -u)" -ne 0 ]; then
  printf "Must be run by root" >&2
  exit 1
fi


if [ -z "$1" ]
then
    printf "Paramters are: dhcp or static"
    exit 2
else
    PARAM=$1
fi


toggle_dhcp () {
    printf "iface lo inet loopback\nauto lo\n\nauto ens192\niface ens192 inet dhcp\n" > /etc/network/interfaces

    printf "IP is set to DHCP"

    CMD_IP="ip a"
    CMD_RESTART="systemctl restart networking.service"

    sleep 2

    eval "$CMD_RESTART"
    printf ""
    eval "$CMD_IP"
}


toggle_static () {
    INTERFACE="ens192"
    IPADDRESS="192.168.1.121"
    IPSUBNET="255.255.255.0"
    IPGATEWAY="192.168.1.1"

    echo "iface lo inet loopback\nauto lo\n\nauto $INTERFACE\nallow-hotplug $INTERFACE\niface $INTERFACE inet static\naddress $IPADDRESS\nnetmask $IPSUBNET\ngateway $IPGATEWAY\n" > /etc/network/interfaces

    printf "IP is set to static"

    CMD_IP="ip a"
    CMD_RESTART="systemctl restart networking.service"

    sleep 2

    eval "$CMD_RESTART"
    printf ""
    eval "$CMD_IP"
}


if [ "$PARAM" = "$DHCP" ]
then
    toggle_dhcp

elif [ "$PARAM" = "$STATIC" ]
then
    toggle_static

else
    printf "Parameter is '$PARAM', must be 'dhcp' or 'static'\n\n"
    exit 3
fi