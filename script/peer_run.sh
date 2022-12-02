#!/bin/sh

# Example
# ./peer_run.sh vanilla 1 50(download) 50(upload) debug

if [ "$5" = "debug" ]; then
    ./binary/$1/downpour -d dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -dl $3 -ul $4
else
    ./binary/$1/downpour dd -t torrent/test.torrent -c config/config.$2.yaml -o data/$2 -dl $3 -ul $4
fi

