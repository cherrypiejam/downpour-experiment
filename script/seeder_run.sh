#!/bin/sh

# Example
# ./seeder_run.sh 0(id) 50(upload) debug

if [ "$3" = "debug" ]; then
    ./binary/vanilla/downpour -d dd -t torrent/test.torrent -c config/config.seed_$1.yaml -o data/seed_$1 --seed -ul $2
else
    ./binary/vanilla/downpour dd -t torrent/test.torrent -c config/config.seed_$1.yaml -o data/seed_$1 --seed -ul $2
fi
