#!/bin/sh

if [ "$1" = "debug" ]; then
    ./binary/chihaya --debug --config config/tracker.yaml
else
    ./binary/chihaya --config config/tracker.yaml
fi

