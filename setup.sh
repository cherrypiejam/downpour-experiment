#!/bin/bash

MACHINES=(
    'pc256.emulab.net' # node 0
    'pc253.emulab.net' # node 1
)

function setup {
    count=0
    for m in "${MACHINES[@]}";
    do
        echo 'Setting things up...' $m
        if [ $count == 0 ]; then
            # Setup seeding machine
            scp launch_w_seeder.sh gongqi@$m:~/launch.sh
        elif [ $count == 1 ]; then
            scp launch_w_tyrant.sh gongqi@$m:~/launch.sh
        elif [ $count == 2 ]; then
            scp launch.sh gongqi@$m:~/launch.sh
        else
            scp launch_wo_high_cap.sh gongqi@$m:~/launch.sh
        fi
        # Dispatch binaries (including tracker)
        scp -r experiment.tar.gz unzip.sh gongqi@$m:~/
        (count++)
    done
}

function collect {
    node=0
    for m in "${MACHINES[@]}";
    do
        echo 'Collecting things...' $m
        if [ $node == 0 ]; then
            scp gongqi@$m:~/data/seed/stats.log result/$node/seed/
        fi
        for p in {1..5}; do # Suppose 5 peers per machine
            scp gongqi@$m:~/data/$p/stats.log result/$node/$p/
        done
        ((node++))
    done
}

if [ "$1" == "collect" ]; then
    collect
else
    setup
fi
