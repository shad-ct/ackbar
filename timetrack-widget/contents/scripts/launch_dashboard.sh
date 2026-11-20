#!/usr/bin/env bash
# Direct launcher for TimeTrack Visual Analytics desktop dashboard window
# Searches multiple install locations so the navbar/widget always finds it.

CANDIDATES=(
    "/home/mrrobot/.local/bin/timetrack-dashboard"
    "$HOME/.local/bin/timetrack-dashboard"
    "/home/mrrobot/Downloads/ackbar/timetrack-dashboard"
    "$HOME/Downloads/ackbar/timetrack-dashboard"
    "$(dirname "$(readlink -f "$0")")/../../../timetrack-dashboard"
)

DASHBOARD_BIN=""
for cand in "${CANDIDATES[@]}"; do
    if [ -x "$cand" ]; then
        DASHBOARD_BIN="$cand"
        break
    fi
done

if [ -z "$DASHBOARD_BIN" ]; then
    echo "[TimeTrack] ERROR: timetrack-dashboard executable not found in any known location." >&2
    exit 1
fi

nohup "$DASHBOARD_BIN" >/tmp/timetrack-dashboard.log 2>&1 &
exit 0
