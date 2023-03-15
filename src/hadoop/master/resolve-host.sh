#!/bin/bash


# Spark requires all hosts to have a hostname that other hosts can resolve. There is no DNS in SNIC...
# delete the entries from hosts..
sudo sed -i '/\[192\.168\]/d' /etc/hosts
for i in {1..4};
do
  for j in {1..255};
  do
      echo "192.168.$i.$j host-192-168-$i-$j" | sudo tee -a /etc/hosts
  done
done
sudo hostname host-$(hostname -I | awk '{$1=$1};1' | sed 's/\./-/'g) ; hostname
# It needs to be set each boot... this doesn't seem to work anyway so we put it in the service script also...
echo @reboot hostname host-$(hostname -I | awk '{$1=$1};1' | sed 's/\./-/'g) | sudo tee -a /etc/crontab
