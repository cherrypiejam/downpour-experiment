
#!/bin/sh
# Generated by scriptgen.py
# Caps [20, 20, 20, 20, 20, 22, 22, 22, 22, 24, 24, 24, 24, 26, 26, 26, 30, 30, 32, 32, 38, 41, 49, 76, 93, 93, 102, 127, 195, 543]
make clean
sleep 1

./script/peer_run.sh vanilla 0 20 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 1 22 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 2 26 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 3 38 > /dev/null 2>&1 &
./script/peer_run.sh vanilla 4 102 > /dev/null 2>&1 &
