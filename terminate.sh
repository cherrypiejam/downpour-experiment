#!/bin/sh

pkill downpour
pkill chihaya
pkill peer_run.sh
sleep 1
kill -9 `pgrep downpour`
kill -9 `pgrep tyrant`
