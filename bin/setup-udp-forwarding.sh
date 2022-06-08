#!/bin/sh

set -e

# Shell script to setup udp port forwarding from public internet host to a internal machine using ssh and socat.

# This code is needed both on the client and the server.

# First start the client socat: 
#    bin/setup-udp-forwarding.sh client

# Then start the ssh forwarding session: 
#    bin/setup-udp-forwarding.sh ssh

# Finally on the ssh forwarding session, start the server socat:
#    bin/setup-udp-forwarding.sh server

# You can monitor the packets received with the following on a machine on the destination network: 
#    bin/setup-udp-forwarding.sh monitor

UDP_ADDR="192.168.33.18"
UDP_PORT="3175"
INTERFACE="br1"

TRANSPORT_PORT="3178"

SSH_SERVER="-o IdentitiesOnly=true -i /home/lochnerr/.ssh/id_ed25519 admin@10.0.33.1"

if [ "$1" = "server" ]; then
  echo "Server socat connecting udp port $UDP_PORT to tcp port $TRANSPORT_PORT."
  socat udp4-listen:$UDP_PORT,reuseaddr,fork        tcp:localhost:$TRANSPORT_PORT
elif [ "$1" = "client" ]; then
  echo "Client socat connecting tcp port $TRANSPORT_PORT to udp on host $UDP_ADDR port $UDP_PORT."
  socat tcp4-listen:$TRANSPORT_PORT,reuseaddr,fork  UDP4:$UDP_ADDR:$UDP_PORT
elif [ "$1" = "ssh" ]; then
  echo "Starting ssh tunneling remote tcp port $TRANSPORT_PORT on server $SSH_SERVER."
  ssh -R $TRANSPORT_PORT:localhost:$TRANSPORT_PORT $SSH_SERVER
elif [ "$1" = "monitor" ]; then
  echo "DUmping packets on interface $INTERFACE for udp port $UDP_PORT."
  tcpdump -i $INTERFACE udp port $UDP_PORT -XAvvv
else
  echo "Unknown parameter $1."
  exit 1
fi

exit 0

