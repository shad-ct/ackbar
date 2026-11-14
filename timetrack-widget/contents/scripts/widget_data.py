#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Self-contained, read-only data provider for TimeTrack Plasma 6 widget.
Queries ~/.local/share/timetracker/timetracker.db directly via standard library sqlite3.
"""
import sqlite3
import os
import json
from datetime import datetime, timedelta

def format_duration(seconds: int) -> str:
    if seconds <= 0:
        return "0m"
    m, s = divmod(int(seconds), 60)
    h, m = divmod(m, 60)
    if h > 0:
        return f"{h}h {m:02d}m"
    if m > 0:
        return f"{m}m"
    return f"{s}s"

def main():
    db_path = os.path.expanduser("~/.local/share/timetracker/timetracker.db")
    if not os.path.exists(db_path) or os.path.getsize(db_path) == 0:
        print(json.dumps({
            "active_formatted": "0m",
            "online_formatted": "0m",
            "active_seconds": 0,
            "online_seconds": 0,
            "current_app": "Tracker Offline",
            "current_duration_formatted": "0s",
            "top_app": "None",
            "top_app_duration": "0s",
            "sparkline": [],
            "is_running": False
        }))
        return

    try:
        conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
        conn.execute("PRAGMA query_only = ON;")
        c = conn.cursor()

        today = datetime.now().strftime("%Y-%m-%d")

        # 1. Today Active Time (non-locked duration)
        c.execute(
            "SELECT COALESCE(SUM(duration_seconds), 0) FROM window_activities WHERE date(start_time) = ? AND is_locked = 0",
            (today,)
        )
        active_sec = c.fetchone()[0]

        # 2. Today Locked Time
        c.execute(
            "SELECT COALESCE(SUM(duration_seconds), 0) FROM window_activities WHERE date(start_time) = ? AND is_locked = 1",
            (today,)
        )
        locked_sec = c.fetchone()[0]
        online_sec = active_sec + locked_sec

        # 3. Current App & Duration (most recent record)
        c.execute(
            "SELECT app_name, duration_seconds, is_locked FROM window_activities ORDER BY id DESC LIMIT 1"
        )
        cur = c.fetchone()
        if cur:
            current_app = "Screen Locked" if cur[2] else (cur[0] or "Idle")
            current_dur = cur[1] or 0
        else:
            current_app = "Idle"
            current_dur = 0

        # 4. Top App Today
        c.execute("""
            SELECT app_name, SUM(duration_seconds) as total
            FROM window_activities
            WHERE date(start_time) = ? AND is_locked = 0 AND app_name IS NOT NULL AND app_name != ''
            GROUP BY app_name
            ORDER BY total DESC
            LIMIT 1
        """, (today,))
        top = c.fetchone()
        top_app = top[0] if top else "None"
        top_dur = top[1] if top else 0

        # 5. 7-Day Sparkline
        days = [(datetime.now() - timedelta(days=i)).strftime("%Y-%m-%d") for i in reversed(range(7))]
        sparkline = []
        for d in days:
            c.execute(
                "SELECT COALESCE(SUM(duration_seconds), 0) FROM window_activities WHERE date(start_time) = ? AND is_locked = 0",
                (d,)
            )
            act = c.fetchone()[0]
            sparkline.append({
                "date": d,
                "active_seconds": act
            })

        conn.close()

        print(json.dumps({
            "active_formatted": format_duration(active_sec),
            "online_formatted": format_duration(online_sec),
            "active_seconds": active_sec,
            "online_seconds": online_sec,
            "current_app": current_app,
            "current_duration_formatted": format_duration(current_dur),
            "top_app": top_app,
            "top_app_duration": format_duration(top_dur),
            "sparkline": sparkline,
            "is_running": True
        }))
    except Exception as e:
        print(json.dumps({
            "active_formatted": "0m",
            "online_formatted": "0m",
            "active_seconds": 0,
            "online_seconds": 0,
            "current_app": "Error",
            "current_duration_formatted": "0s",
            "top_app": "None",
            "top_app_duration": "0s",
            "sparkline": [],
            "is_running": False,
            "error": str(e)
        }))

if __name__ == "__main__":
    main()
