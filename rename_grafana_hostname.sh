#!/bin/bash

# HOSTNAME=$1
# if [ -z "$1" ]; then
#     echo "No new hostname provided."
#     exit
# fi
read -p "Type new hostname: " HOSTNAME

YML_PATH="/etc/prometheus/prometheus.yml"
if [ ! -z "$1" ]; then
    YML_PATH="$1"
fi

if [ -f $YML_PATH ]; then
    sudo sed -i "s/hostname:.*/hostname: '$HOSTNAME'/g" $YML_PATH
    sudo sed -i "s/replacement:.*/replacement: '$HOSTNAME'/g" $YML_PATH
else
    echo "No prometeus.yml file to update."
fi

sudo systemctl daemon-reload
sudo systemctl enable vmagent && sudo systemctl restart vmagent
sudo systemctl enable node_exporter && sudo systemctl restart node_exporter
echo "Done."