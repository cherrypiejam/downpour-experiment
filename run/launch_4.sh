#!/bin/sh

# Clean up
make clean

sleep 1

./script/peer_run.sh vanilla 0 15 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 1 18 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 32 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 3 50 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 70 > /dev/null 2>&1 &
