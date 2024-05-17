#!/bin/bash

NSLXX=../build/src/nslxx

cat $1 | $NSLXX
if [ $? -ne 0 ]; then
    echo "Failed to compile $1"
    exit 1
fi

exit 0
