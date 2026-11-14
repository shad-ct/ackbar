#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Helper script to output compact JSON payload for TimeTrack Plasma 6 widget.
"""
import sys
import json
from pathlib import Path
from datetime import datetime

# Add project root to sys.path
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from backend.db_reader import TimeTrackDBReader
from backend.query_service import TimeTrackQueryService, format_seconds, format_seconds_short


def get_widget_payload() -> dict:
    reader = TimeTrackDBReader()
    if not reader.exists():
        return {
            "active_formatted": "0m",
            "online_formatted": "0m",
            "active_seconds": 0,
            "online_seconds": 0,
            "current_app": "Tracker Offline",
            "current_duration_formatted": "0s",
            "top_app": "None",
            "top_app_duration": "0s",
            "sparkline": []
        }

    qs = TimeTrackQueryService(reader)
    bounds = qs.get_date_bounds()
    target_date = datetime.now().strftime("%Y-%m-%d")
    status = qs.get_live_status()
    ov = qs.get_overview(target_date, target_date)

    daily_analytics = qs.get_daily_analytics(target_date)
    top_apps = daily_analytics.get("top_applications", [])
    top_app = top_apps[0]["app_name"] if top_apps else "None"
    top_app_duration = top_apps[0]["duration_formatted"] if top_apps else "0s"

    weekly = qs.get_weekly_analytics(target_date)
    sparkline = weekly.get("current", {}).get("activity_trend", [])
    top_apps = weekly.get("current", {}).get("top_apps", [])
    top_app = top_apps[0]["name"] if top_apps else "None"
    top_app_duration = top_apps[0]["formatted"] if top_apps else "0s"

    return {
        "active_formatted": ov.get("active_formatted", "0m"),
        "online_formatted": ov.get("online_formatted", "0m"),
        "active_seconds": ov.get("active_time", 0),
        "online_seconds": ov.get("online_time", 0),
        "current_app": status.get("current_app", "Idle"),
        "current_duration": status.get("current_duration_seconds", 0),
        "current_duration_formatted": status.get("current_duration_formatted", "0s"),
        "top_app": top_app,
        "top_app_duration": top_app_duration,
        "sparkline": sparkline
    }


if __name__ == "__main__":
    print(json.dumps(get_widget_payload()))
