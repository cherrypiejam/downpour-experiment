#!/bin/sh

# Clean up
make clean

# Tracker
./script/tracker_run.sh                > /dev/null 2>&1 &

sleep 1

# Some seeder
./script/seeder_run.sh 50              > /dev/null 2>&1 &

# Some poor peer
./script/peer_run.sh vanilla 1 50 20 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 60 30 > /dev/null 2>&1 &

# Some peer
./script/peer_run.sh vanilla 3 100 100 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 100 100 > /dev/null 2>&1 &

# High cap peer
./script/peer_run.sh vanilla 5 130 200 > /dev/null 2>&1 &
