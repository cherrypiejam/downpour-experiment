#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    tar -xzvf experiment.tar.gz
else
    echo "oops plz don't try that on your machine :)"
fi
