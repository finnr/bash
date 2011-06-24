#!/bin/bash
# ln -s /root/screen.sh /usr/bin/scr
# scr
SCREEN_NAME=$1;
if [ -z "$SCREEN_NAME" ]; then
    SCREEN_NAME=`echo $SSH_CLIENT | awk '{print $1}'`;
fi
CHECK=`/usr/bin/screen -list | grep "\.$SCREEN_NAME\s"`;
if [ -n "$CHECK" ];
then
    screen -rD $SCREEN_NAME;
else
    screen -S $SCREEN_NAME;
fi
