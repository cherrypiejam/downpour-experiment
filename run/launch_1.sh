#!/bin/sh

# Clean up
make clean

sleep 1

./script/peer_run.sh vanilla 0 10  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 1 15  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 25  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 3 50  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 100 > /dev/null 2>&1 &
