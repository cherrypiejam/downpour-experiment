#!/bin/sh

# Clean up
make clean

sleep 1

# TODO scaling down the download/upload seed due to the total bandwidth
# TODO add a script to collect.sh and analysis.sh data
# TODO reduce the size of the downloading file

# Some poor peer
./script/peer_run.sh vanilla 1 50 30 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 60 40 > /dev/null 2>&1 &

# Some peer
# ./script/peer_run.sh tyrant  3 100 100 > /dev/null 2>&1 &
# ./script/peer_run.sh tyrant  3 100 100 > result/3/debug.log &
./script/peer_run.sh tyrant  3 100 100  &
./script/peer_run.sh vanilla 4 100 100 > /dev/null 2>&1 &

# High cap peer
./script/peer_run.sh vanilla 5 130 200 > /dev/null 2>&1 &
