#!/bin/bash

MACHINES=(
    'pc272.emulab.net' # node 0
    'pc340.emulab.net'
    'pc330.emulab.net'
    'pc356.emulab.net'
    'pc326.emulab.net'
    'pc339.emulab.net'
    'pc354.emulab.net'
)

function dryrun {
    for m in "${MACHINES[@]}";
    do
        scp -r empty gongqi@$m:~/tmp/
    done
}

function setup {
    FAIL=0
    PIDS=""
    count=0
    for m in "${MACHINES[@]}";
    do
        echo 'Setting things up...' $m
        if [ $count == 0 ]; then
            scp run/10_tyrant/launch_w_seeder.sh gongqi@$m:~/launch.sh &
        else
            scp run/10_tyrant/launch_gen_$count.sh gongqi@$m:~/launch.sh &
        fi
        PIDS="$PIDS $!"
        # Dispatch binaries (including tracker)
        scp -r experiment.tar.gz unzip.sh gongqi@$m:~/ &
        PIDS="$PIDS $!"
        ((count++))
    done
    for job in $PIDS; do
        wait $job || let "FAIL+=1"
        echo $job $FAIL
    done
}

function setup_tyrant {
    FAIL=0
    PIDS=""
    count=0
    for m in "${MACHINES[@]}";
    do
        echo 'Setting things up...' $m
        if [ $count == 0 ]; then
            scp run/10/launch_w_seeder.sh gongqi@$m:~/launch.sh &
        elif [ $count == 1 ]; then
            scp run/10/launch_gen_sybil_$count.sh gongqi@$m:~/launch.sh &
        else
            scp run/10/launch_gen_$count.sh gongqi@$m:~/launch.sh &
        fi
        PIDS="$PIDS $!"
        # Dispatch binaries (including tracker)
        scp -r experiment.tar.gz unzip.sh gongqi@$m:~/ &
        PIDS="$PIDS $!"
        ((count++))
    done
    for job in $PIDS; do
        wait $job || let "FAIL+=1"
        echo $job $FAIL
    done
}

function collect {
    for i in {0..0}; do # Suppose 10 peers per machine
        node=0
        for m in "${MACHINES[@]}"; do
            echo 'Collecting things...' $m
            if [ $node == 0 ]; then
                echo 'skip node 0'
            else
                FAIL=0
                PIDS=""
                begin=$((i * 10))
                end=$((begin + 9))
                for p in $(seq $begin $end); do
                    scp gongqi@$m:~/data/$p/stats.log result/$node/$p/ &
                    PIDS="$PIDS $!"
                done
                for job in $PIDS; do
                    wait $job || let "FAIL+=1"
                    echo $job $FAIL
                done
            fi
            ((node++))
        done
    done
}

if [ "$1" == "dryrun" ]; then
    dryrun
elif [ "$1" == "collect" ]; then
    collect
elif [ "$1" == "tyrant" ]; then
    setup_tyrant
else
    setup
fi
