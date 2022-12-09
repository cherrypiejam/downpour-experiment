#!/bin/sh

# Clean up
make clean

sleep 1

./script/peer_run.sh vanilla 0 12  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 1 15  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 20  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 3 75  > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 150 > /dev/null 2>&1 &
