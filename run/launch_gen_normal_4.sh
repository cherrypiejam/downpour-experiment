
#!/bin/sh
# Generated by scriptgen.py
# Caps [20, 25, 30, 31, 32, 35, 35, 38, 39, 40, 40, 41, 43, 44, 47, 48, 48, 48, 49, 49, 51, 52, 52, 53, 56, 57, 57, 60, 67, 69]
make clean
sleep 1

./script/peer_run.sh vanilla 0 31 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 1 40 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 48 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 3 52 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 60 > /dev/null 2>&1 &
