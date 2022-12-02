#!/bin/bash

SESSION='cloudlab'
MACHINES=(
    'pc256.emulab.net' # node 0
    'pc253.emulab.net' # node 1
)

tmux has-session -t $SESSION &> /dev/null
if [ $? != 0 ]
then
    count=0
    for m in "${MACHINES[@]}";
    do
        if [ $((count++)) == 0 ]
        then
            tmux new-session -s $SESSION -n "seed" -d
        else
            if [ $((count % 2)) == 0 ] # FIXME may out of space
            then
                tmux split-window -t $SESSION:0 -v
            else
                tmux split-window -t $SESSION:0 -h
            fi
        fi
        tmux send-keys -t $SESSION:0 "ssh -p 22 gongqi@$m" C-m
    done
fi
tmux select-layout tiled # re-arrange panes
tmux setw synchronize-panes on
# tmux send-keys -t $SESSION:0 "echo SEND TO ALL!!!!" C-m
tmux select-window -t $SESSION:0
tmux attach -t $SESSION

