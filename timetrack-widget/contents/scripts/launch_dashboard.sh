#!/usr/bin/env bash
# Direct launcher for TimeTrack Visual Analytics desktop dashboard window

DASHBOARD_BIN="/home/mrrobot/.local/bin/timetrack-dashboard"
if [ ! -x "${DASHBOARD_BIN}" ]; then
    DASHBOARD_BIN="/home/mrrobot/Downloads/ackbar/timetrack-dashboard"
fi

nohup "${DASHBOARD_BIN}" >/tmp/timetrack-dashboard.log 2>&1 &
exit 0
