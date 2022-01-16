#!/usr/bin/env bash
# Break script on any non-zero status of any command
set -e

export DISPLAY SCREEN_NUM SCREEN_WHD

XVFB_PID=0
TERMINAL_PID=0

term_handler() {
    echo '########################################'
    echo 'SIGTERM signal received'

    if ps -p $TERMINAL_PID > /dev/null; then
        kill -SIGTERM $TERMINAL_PID
        # Wait returns status of the killed process, with set -e this breaks the script
        wait $TERMINAL_PID || true
    fi

    # Wait end of all wine processes
    /docker/waitonprocess.sh wineserver

    if ps -p $XVFB_PID > /dev/null; then
        kill -SIGTERM $XVFB_PID
        # Wait returns status of the killed process, with set -e this breaks the script
        wait $XVFB_PID || true
    fi

    # SIGTERM comes from docker stop so treat it as normal signal
    exit 0
}

trap 'term_handler' SIGTERM
#SCREEN_NUM=1920
#SCREEN_WHD=1080
Xvfb $DISPLAY -screen $SCREEN_NUM $SCREEN_WHD \
    +extension GLX \
    +extension RANDR \
    +extension RENDER \
    &> /tmp/xvfb.log &
XVFB_PID=$!
#sleep 2
#x11vnc -bg -nopw -rfbport 5900 -forever -xkb -o /tmp/x11vnc.log
sleep 2
# @TODO Use special argument to pass value "startup.ini"
nl=$'\n'
#mv experts.ini config/
echo "${nl}IvInvest=$IVINVEST_ID${nl}WebHost=$IBOT_HOST${nl}WebPort=$IBOT_PORT${nl}" >> MQL4/Presets/ibot.set 
echo "${nl}Login=$MT4_ACCOUNT${nl}Password=$MT4_PASSWORD${nl}" >> startup.ini 

node MQL4/Node/wss_http_server.js &
wine terminal /portable startup.ini &

TERMINAL_PID=$!

# Wait end of terminal
wait $TERMINAL_PID
# Wait end of all wine processes
#
#Login=1755661
#Password=8Rrkck2Q
/docker/waitonprocess.sh wineserver
# Wait end of Xvfb
wait $XVFB_PID