#!/bin/sh

# Example
# ./seeder_run.sh 50(upload) debug

if [ "$2" = "debug" ]; then
    ./binary/vanilla/downpour -d dd -t torrent/test.torrent -c config/config.0.yaml -o data/seed --seed -ul $1
else
    ./binary/vanilla/downpour dd -t torrent/test.torrent -c config/config.0.yaml -o data/seed --seed -ul $1
fi
