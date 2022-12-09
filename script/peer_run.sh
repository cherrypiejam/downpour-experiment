#!/bin/sh

# Example
# ./peer_run.sh vanilla 1 50(upload) debug

echo > data/$2/stats.log
while true
do
    ./binary/$1/downpour dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -ul $3
    rm data/$2/test.img*
    echo $1 $2 finished in `cat data/$2/stats.log`
    sleep 1
done


# if [ "$4" = "debug" ]; then
    # ./binary/$1/downpour -d dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -ul $3
# else
    # ./binary/$1/downpour dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -ul $3
# fi

# if [ "$5" = "debug" ]; then
    # ./binary/$1/downpour -d dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -dl $3 -ul $4
# else
    # ./binary/$1/downpour dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -dl $3 -ul $4
# fi

