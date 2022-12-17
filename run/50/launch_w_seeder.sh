#!/bin/sh

# Clean up
make clean

# Tracker
./script/tracker_run.sh > /dev/null 2>&1 &

sleep 1

# Some seeder
./script/seeder_run.sh 0 64 0.44 > /dev/null 2>&1 &
# TODO no seed in 1, 2
./script/seeder_run.sh 1 32 0.44 > /dev/null 2>&1 &
./script/seeder_run.sh 2 32 0.44 > /dev/null 2>&1 &
