#!/bin/bash
sudo apt update
sudo apt install isc-dhcp-server

if [ "$(id -u)" -ne 0 ]; then
  printf "Must be run by root" >&2
  exit 1
fi

sudo printf 'INTERFACES="ens33"' > /etc/default/isc-dhcp-server
sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd-backup.conf


input="/home/dar/Documenten/dhcpranges.txt"
while IFS= read -r line
do
  printf "$line\n" >> /etc/dhcp/dhcpd.conf
done < "$input"


printf "" >> /etc/network/interfaces 
input2="/home/dar/Documenten/staticconfig.txt"
while IFS= read -r line
do
  printf "$line\n" >> /etc/network/interfaces
done < "$input2"

sudo systemctl start isc-dhcp-server
sudo systemctl enable isc-dhcp-server
sudo systemctl status isc-dhcp-server