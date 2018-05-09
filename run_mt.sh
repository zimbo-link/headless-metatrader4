#!/usr/bin/env bash
# Break script on any non-zero status of any command
set -e

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

export DISPLAY=:1

Xvfb $DISPLAY -screen 0 1366x768x24 \
    +extension GLX \
    +extension RANDR \
    +extension RENDER \
    &> /tmp/xvfb.log &
XVFB_PID=$!
sleep 2

wine terminal /portable myfxbook_ea.ini &
TERMINAL_PID=$!

# Wait end of terminal
wait $TERMINAL_PID
# Wait end of all wine processes
/docker/waitonprocess.sh wineserver
# Wait end of Xvfb
wait $XVFB_PID