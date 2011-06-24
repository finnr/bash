#!/bin/bash

if [ -z "$1" ]; then
    echo "NO SCREEN!";
    exit 0;
fi

CHECK=`/usr/bin/screen -list | grep "\.$1\s"`;
if [ -n "$CHECK" ];
then
    screen -rD $1;
else
    screen -S $1;
fi

