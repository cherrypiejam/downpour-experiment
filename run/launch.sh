#!/bin/sh

# Clean up
make clean

sleep 1

# TODO scaling down the download/upload seed due to the total bandwidth

# Some poor peer
./script/peer_run.sh vanilla 1 50 20 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 60 30 > /dev/null 2>&1 &

# Some peer
./script/peer_run.sh vanilla 3 100 100 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 100 100 > /dev/null 2>&1 &

# High cap peer
./script/peer_run.sh vanilla 5 100 150 > /dev/null 2>&1 &
