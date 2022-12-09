#!/bin/bash

MACHINES=(
    'pc553.emulab.net' # node 0
    'pc532.emulab.net'
    'pc521.emulab.net'
    'pc527.emulab.net'
    'pc546.emulab.net'
    'pc559.emulab.net'
    'pc552.emulab.net'
)

function setup {
    count=0
    for m in "${MACHINES[@]}";
    do
        echo 'Setting things up...' $m
        if [ $count == 0 ]; then
            scp run/launch_w_seeder.sh gongqi@$m:~/launch.sh &
        else
            scp run/launch_$count.sh gongqi@$m:~/launch.sh &
        fi
        # Dispatch binaries (including tracker)
        scp -r experiment.tar.gz unzip.sh gongqi@$m:~/ &
        ((count++))
    done
}

function setup_tyrant {
    count=0
    for m in "${MACHINES[@]}";
    do
        echo 'Setting things up...' $m
        if [ $count == 0 ]; then
            scp run/launch_w_seeder.sh gongqi@$m:~/launch.sh &
        elif [ $count == 1 ]; then
            scp run/launch_tyrant_$count.sh gongqi@$m:~/launch.sh &
        else
            scp run/launch_$count.sh gongqi@$m:~/launch.sh &
        fi
        # Dispatch binaries (including tracker)
        scp -r experiment.tar.gz unzip.sh gongqi@$m:~/ &
        ((count++))
    done
}

function collect {
    node=0
    for m in "${MACHINES[@]}";
    do
        echo 'Collecting things...' $m
        if [ $node == 0 ]; then
            echo 'skip node 0'
        else
            for p in {0..4}; do # Suppose 5 peers per machine
                scp gongqi@$m:~/data/$p/stats.log result/$node/$p/ &
            done
        fi
        ((node++))
    done
}

if [ "$1" == "collect" ]; then
    collect
elif [ "$1" == "tyrant" ]; then
    setup_tyrant
else
    setup
fi
