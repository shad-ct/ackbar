#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Query service for TimeTrack Visual Analytics.
Handles date math, aggregations, timelines, KPIs, application stats,
and paginated historical searching.
"""

import datetime
from typing import Dict, List, Any, Optional, Tuple
from .db_reader import TimeTrackDBReader

CANONICAL_CATEGORIES = {
    "browsing": {"name": "Web Browsing", "icon": "🌐", "color": "#3498db"},
    "media": {"name": "Media & Gaming", "icon": "🎬", "color": "#e74c3c"},
    "development": {"name": "Development", "icon": "💻", "color": "#2ecc71"},
    "communication": {"name": "Communication", "icon": "💬", "color": "#9b59b6"},
    "system": {"name": "System & Desktop", "icon": "⚙️", "color": "#95a5a6"},
    "terminal": {"name": "Terminal & Ops", "icon": "📟", "color": "#1abc9c"},
    "notes": {"name": "Notes & Docs", "icon": "📝", "color": "#f39c12"},
    "design": {"name": "Design & Creative", "icon": "🎨", "color": "#e67e22"},
    "other": {"name": "Other Apps", "icon": "📌", "color": "#7f8c8d"},
    "locked": {"name": "Locked / Away", "icon": "🔒", "color": "#34495e"}
}


def format_seconds(seconds: int) -> str:
    """Formats seconds into human-readable duration (e.g., '2h 15m' or '45s')."""
    if seconds <= 0:
        return "0s"
    h = seconds // 3600
    m = (seconds % 3600) // 60
    s = seconds % 60
    if h > 0:
        return f"{h}h {m:02d}m"
    elif m > 0:
        return f"{m}m {s:02d}s"
    else:
        return f"{s}s"


def format_seconds_short(seconds: int) -> str:
    """Formats seconds compactly (e.g. '2.5h' or '45m')."""
    if seconds <= 0:
        return "0m"
    if seconds >= 3600:
        return f"{seconds / 3600:.1f}h"
    return f"{seconds // 60}m"


class TimeTrackQueryService:
    def __init__(self, db_reader: Optional[TimeTrackDBReader] = None):
        self.reader = db_reader or TimeTrackDBReader()

    def get_live_status(self) -> Dict[str, Any]:
        """Returns the current tracker service status and latest active window."""
        is_active = self.reader.is_service_active()
        latest_row = self.reader.query_one(
            "SELECT * FROM window_activities ORDER BY id DESC LIMIT 1;"
        )

        if not latest_row:
            return {
                "service_active": is_active,
                "latest_captured": None,
                "current_app": "None",
                "current_title": "No records in database",
                "current_category": "other",
                "current_category_name": "Other",
                "current_category_icon": "📌",
                "current_duration": 0,
                "current_duration_formatted": "0s",
                "is_locked": False
            }

        cat_key = latest_row["category"]
        cat_info = CANONICAL_CATEGORIES.get(cat_key, CANONICAL_CATEGORIES["other"])
        dur = latest_row["duration_seconds"]

        return {
            "service_active": is_active,
            "latest_captured": latest_row["end_time"],
            "current_app": latest_row["app_name"],
            "current_title": latest_row["window_title"],
            "current_category": cat_key,
            "current_category_name": cat_info["name"],
            "current_category_icon": cat_info["icon"],
            "current_duration": dur,
            "current_duration_formatted": format_seconds(dur),
            "is_locked": bool(latest_row["is_locked"])
        }

    def get_date_bounds(self) -> Dict[str, Any]:
        """Returns the earliest and latest recorded dates, plus counts."""
        res = self.reader.query_one("""
            SELECT 
                MIN(date(start_time)) as min_date,
                MAX(date(end_time)) as max_date,
                COUNT(DISTINCT date(start_time)) as tracked_days,
                COUNT(*) as total_records
            FROM window_activities;
        """)
        if not res or not res["min_date"]:
            today = datetime.date.today().strftime("%Y-%m-%d")
            return {
                "min_date": today,
                "max_date": today,
                "tracked_days": 0,
                "total_records": 0
            }
        return res

    def get_overview(self, start_date: str, end_date: str) -> Dict[str, Any]:
        """Calculates primary KPIs, secondary metrics, and chart series for a date range."""
        params = (start_date, end_date)

        # 1. Total active, locked, online time
        totals = self.reader.query_one("""
            SELECT 
                COALESCE(SUM(CASE WHEN is_locked = 0 THEN duration_seconds ELSE 0 END), 0) as active_time,
                COALESCE(SUM(CASE WHEN is_locked = 1 THEN duration_seconds ELSE 0 END), 0) as locked_time,
                COALESCE(SUM(duration_seconds), 0) as online_time,
                COUNT(DISTINCT app_name) as app_count,
                COUNT(*) as session_count,
                COUNT(DISTINCT date(start_time)) as active_days_count
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?);
        """, params) or {}

        active_time = totals.get("active_time", 0)
        locked_time = totals.get("locked_time", 0)
        online_time = totals.get("online_time", 0)
        app_count = totals.get("app_count", 0)
        session_count = totals.get("session_count", 0)
        active_days = max(1, totals.get("active_days_count", 1))

        pct_active = round((active_time / online_time * 100), 1) if online_time else 0.0
        pct_locked = round((locked_time / online_time * 100), 1) if online_time else 0.0

        # 2. Longest continuous active session
        longest_row = self.reader.query_one("""
            SELECT app_name, window_title, duration_seconds
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
              AND is_locked = 0
            ORDER BY duration_seconds DESC
            LIMIT 1;
        """, params)

        longest_session = {
            "app_name": longest_row["app_name"] if longest_row else "None",
            "window_title": longest_row["window_title"] if longest_row else "None",
            "duration": longest_row["duration_seconds"] if longest_row else 0,
            "formatted": format_seconds(longest_row["duration_seconds"]) if longest_row else "0s"
        }

        # 3. Top category
        top_cat_row = self.reader.query_one("""
            SELECT category, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
              AND is_locked = 0
            GROUP BY category
            ORDER BY total_dur DESC
            LIMIT 1;
        """, params)
        top_cat_key = top_cat_row["category"] if top_cat_row else "other"
        top_cat_info = CANONICAL_CATEGORIES.get(top_cat_key, CANONICAL_CATEGORIES["other"])

        # 4. Top application
        top_app_row = self.reader.query_one("""
            SELECT app_name, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
              AND is_locked = 0
            GROUP BY app_name
            ORDER BY total_dur DESC
            LIMIT 1;
        """, params)

        # 5. Highest and lowest activity days in range
        day_stats = self.reader.query("""
            SELECT 
                date(start_time) as day_date,
                SUM(CASE WHEN is_locked = 0 THEN duration_seconds ELSE 0 END) as active_dur
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
            GROUP BY day_date
            ORDER BY active_dur DESC;
        """, params)

        highest_day = {"date": day_stats[0]["day_date"], "duration": day_stats[0]["active_dur"], "formatted": format_seconds(day_stats[0]["active_dur"])} if day_stats else {"date": "None", "duration": 0, "formatted": "0s"}
        lowest_day = {"date": day_stats[-1]["day_date"], "duration": day_stats[-1]["active_dur"], "formatted": format_seconds(day_stats[-1]["active_dur"])} if day_stats else {"date": "None", "duration": 0, "formatted": "0s"}

        # 6. Category distribution series
        cat_rows = self.reader.query("""
            SELECT category, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
              AND is_locked = 0
            GROUP BY category
            ORDER BY total_dur DESC;
        """, params)

        cat_dist = []
        for r in cat_rows:
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])
            cdur = r["total_dur"]
            c_pct = round((cdur / active_time * 100), 1) if active_time else 0.0
            cat_dist.append({
                "category": ck,
                "name": cinfo["name"],
                "icon": cinfo["icon"],
                "color": cinfo["color"],
                "duration": cdur,
                "formatted": format_seconds(cdur),
                "percent": c_pct
            })

        # 7. Top applications series (up to 8)
        app_rows = self.reader.query("""
            SELECT app_name, app_id, category, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
              AND is_locked = 0
            GROUP BY app_name
            ORDER BY total_dur DESC
            LIMIT 8;
        """, params)

        top_apps = []
        for r in app_rows:
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])
            adur = r["total_dur"]
            a_pct = round((adur / active_time * 100), 1) if active_time else 0.0
            top_apps.append({
                "name": r["app_name"],
                "app_id": r["app_id"],
                "category": ck,
                "category_name": cinfo["name"],
                "color": cinfo["color"],
                "duration": adur,
                "formatted": format_seconds(adur),
                "percent": a_pct
            })

        # 8. Activity trend series (daily)
        trend_rows = self.reader.query("""
            SELECT 
                date(start_time) as day_date,
                COALESCE(SUM(CASE WHEN is_locked = 0 THEN duration_seconds ELSE 0 END), 0) as active_dur,
                COALESCE(SUM(CASE WHEN is_locked = 1 THEN duration_seconds ELSE 0 END), 0) as locked_dur,
                COALESCE(SUM(duration_seconds), 0) as online_dur
            FROM window_activities
            WHERE date(start_time) >= date(?) AND date(start_time) <= date(?)
            GROUP BY day_date
            ORDER BY day_date ASC;
        """, params)

        trend_map = {r["day_date"]: r for r in trend_rows}
        # Build complete continuous series between start_date and end_date
        trend_series = []
        try:
            s_dt = datetime.date.fromisoformat(start_date)
            e_dt = datetime.date.fromisoformat(end_date)
            curr = s_dt
            while curr <= e_dt:
                d_str = curr.strftime("%Y-%m-%d")
                row = trend_map.get(d_str)
                trend_series.append({
                    "date": d_str,
                    "active_seconds": row["active_dur"] if row else 0,
                    "locked_seconds": row["locked_dur"] if row else 0,
                    "online_seconds": row["online_dur"] if row else 0,
                    "has_data": row is not None
                })
                curr += datetime.timedelta(days=1)
        except Exception:
            trend_series = [{"date": r["day_date"], "active_seconds": r["active_dur"], "locked_seconds": r["locked_dur"], "online_seconds": r["online_dur"], "has_data": True} for r in trend_rows]

        return {
            "start_date": start_date,
            "end_date": end_date,
            # Primary KPIs
            "active_time": active_time,
            "active_formatted": format_seconds(active_time),
            "locked_time": locked_time,
            "locked_formatted": format_seconds(locked_time),
            "online_time": online_time,
            "online_formatted": format_seconds(online_time),
            "active_percent": pct_active,
            "locked_percent": pct_locked,
            "app_count": app_count,
            "session_count": session_count,
            "longest_session": longest_session,
            # Secondary Metrics
            "top_app": {
                "name": top_app_row["app_name"] if top_app_row else "None",
                "duration": top_app_row["total_dur"] if top_app_row else 0,
                "formatted": format_seconds(top_app_row["total_dur"]) if top_app_row else "0s"
            },
            "top_category": {
                "key": top_cat_key,
                "name": top_cat_info["name"],
                "icon": top_cat_info["icon"],
                "duration": top_cat_row["total_dur"] if top_cat_row else 0,
                "formatted": format_seconds(top_cat_row["total_dur"]) if top_cat_row else "0s"
            },
            "daily_avg_active": active_time // active_days if active_days else 0,
            "daily_avg_active_formatted": format_seconds(active_time // active_days) if active_days else "0s",
            "highest_day": highest_day,
            "lowest_day": lowest_day,
            # Charts
            "category_distribution": cat_dist,
            "top_apps": top_apps,
            "activity_trend": trend_series,
            "focus_distribution": {
                "active_seconds": active_time,
                "locked_seconds": locked_time,
                "active_percent": pct_active,
                "locked_percent": pct_locked
            }
        }

    def get_daily_analytics(self, target_date: str) -> Dict[str, Any]:
        """Detailed breakdown for a single 24-hour day."""
        overview = self.get_overview(target_date, target_date)

        # 24-hour hourly usage distribution
        hourly_rows = self.reader.query("""
            SELECT 
                CAST(strftime('%H', start_time) AS INTEGER) as hour,
                COALESCE(SUM(CASE WHEN is_locked = 0 THEN duration_seconds ELSE 0 END), 0) as active_dur,
                COALESCE(SUM(duration_seconds), 0) as online_dur
            FROM window_activities
            WHERE date(start_time) = date(?)
            GROUP BY hour
            ORDER BY hour ASC;
        """, (target_date,))

        hourly_map = {r["hour"]: r for r in hourly_rows}
        hourly_dist = []
        for h in range(24):
            item = hourly_map.get(h)
            hourly_dist.append({
                "hour": h,
                "label": f"{h:02d}:00",
                "active_seconds": item["active_dur"] if item else 0,
                "online_seconds": item["online_dur"] if item else 0,
                "formatted": format_seconds_short(item["active_dur"]) if item else "0m"
            })

        # Key window tasks / titles
        window_rows = self.reader.query("""
            SELECT app_name, window_title, category, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE date(start_time) = date(?) AND is_locked = 0
            GROUP BY app_name, window_title
            ORDER BY total_dur DESC
            LIMIT 10;
        """, (target_date,))

        top_windows = []
        for r in window_rows:
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])
            dur = r["total_dur"]
            top_windows.append({
                "app_name": r["app_name"],
                "window_title": r["window_title"] or "Untitled",
                "category": ck,
                "category_icon": cinfo["icon"],
                "color": cinfo["color"],
                "duration": dur,
                "formatted": format_seconds(dur)
            })

        # Date navigation
        try:
            curr_dt = datetime.date.fromisoformat(target_date)
            prev_date = (curr_dt - datetime.timedelta(days=1)).strftime("%Y-%m-%d")
            next_date = (curr_dt + datetime.timedelta(days=1)).strftime("%Y-%m-%d")
        except Exception:
            prev_date = target_date
            next_date = target_date

        return {
            "date": target_date,
            "prev_date": prev_date,
            "next_date": next_date,
            "overview": overview,
            "hourly_distribution": hourly_dist,
            "top_windows": top_windows
        }

    def get_timeline_blocks(self, target_date: str, app_filter: str = "", category_filter: str = "") -> List[Dict[str, Any]]:
        """Extracts chronological visual blocks from 00:00 to 24:00 for the daily timeline."""
        sql = """
            SELECT 
                id, start_time, end_time, duration_seconds,
                app_name, app_id, window_title, category, is_locked, is_idle
            FROM window_activities
            WHERE date(start_time) = date(?)
        """
        params = [target_date]
        if app_filter:
            sql += " AND app_name LIKE ?"
            params.append(f"%{app_filter}%")
        if category_filter and category_filter != "all":
            sql += " AND category = ?"
            params.append(category_filter)

        sql += " ORDER BY start_time ASC;"
        rows = self.reader.query(sql, tuple(params))

        blocks = []
        for r in rows:
            st = r["start_time"]
            et = r["end_time"]
            dur = r["duration_seconds"]
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])

            # Compute minute offsets within the 24h day (0 to 1440 minutes)
            try:
                s_dt = datetime.datetime.fromisoformat(st)
                start_minute = s_dt.hour * 60 + s_dt.minute + s_dt.second / 60.0
            except Exception:
                start_minute = 0

            duration_minutes = max(0.5, dur / 60.0)

            blocks.append({
                "id": r["id"],
                "app_name": r["app_name"],
                "app_id": r["app_id"],
                "window_title": r["window_title"] or "Untitled",
                "category": ck,
                "category_name": cinfo["name"],
                "icon": cinfo["icon"],
                "color": cinfo["color"],
                "start_time": st,
                "end_time": et,
                "duration_seconds": dur,
                "duration_formatted": format_seconds(dur),
                "is_locked": bool(r["is_locked"]),
                "is_idle": bool(r["is_idle"]),
                "start_minute": round(start_minute, 2),
                "duration_minutes": round(duration_minutes, 2)
            })

        return blocks

    def get_multi_day_timeline(self, start_date: str, end_date: str, limit_days: int = 7) -> List[Dict[str, Any]]:
        """Returns stacked visual timelines for multiple consecutive days."""
        days = []
        try:
            s_dt = datetime.date.fromisoformat(start_date)
            e_dt = datetime.date.fromisoformat(end_date)
            curr = e_dt
            count = 0
            while curr >= s_dt and count < limit_days:
                d_str = curr.strftime("%Y-%m-%d")
                blocks = self.get_timeline_blocks(d_str)
                active_secs = sum(b["duration_seconds"] for b in blocks if not b["is_locked"])
                online_secs = sum(b["duration_seconds"] for b in blocks)
                days.append({
                    "date": d_str,
                    "active_seconds": active_secs,
                    "online_seconds": online_secs,
                    "active_formatted": format_seconds(active_secs),
                    "blocks": blocks
                })
                curr -= datetime.timedelta(days=1)
                count += 1
        except Exception:
            pass
        return days

    def get_weekly_analytics(self, end_date: str) -> Dict[str, Any]:
        """Calculates 7-day analytics and compares against previous 7-day period."""
        try:
            e_dt = datetime.date.fromisoformat(end_date)
            s_dt = e_dt - datetime.timedelta(days=6)
            prev_e_dt = s_dt - datetime.timedelta(days=1)
            prev_s_dt = prev_e_dt - datetime.timedelta(days=6)

            curr_overview = self.get_overview(s_dt.strftime("%Y-%m-%d"), e_dt.strftime("%Y-%m-%d"))
            prev_overview = self.get_overview(prev_s_dt.strftime("%Y-%m-%d"), prev_e_dt.strftime("%Y-%m-%d"))

            # Calculate delta %
            prev_active = prev_overview["active_time"]
            curr_active = curr_overview["active_time"]
            if prev_active > 0:
                delta_pct = round(((curr_active - prev_active) / prev_active * 100), 1)
            else:
                delta_pct = 100.0 if curr_active > 0 else 0.0

            return {
                "start_date": s_dt.strftime("%Y-%m-%d"),
                "end_date": e_dt.strftime("%Y-%m-%d"),
                "prev_start_date": prev_s_dt.strftime("%Y-%m-%d"),
                "prev_end_date": prev_e_dt.strftime("%Y-%m-%d"),
                "current": curr_overview,
                "previous": prev_overview,
                "delta_percent": delta_pct
            }
        except Exception as e:
            return {"error": str(e)}

    def get_monthly_analytics(self, year: int, month: int) -> Dict[str, Any]:
        """Calculates monthly stats, calendar heatmap, and prior month comparison."""
        start_date = f"{year:04d}-{month:02d}-01"
        # Compute last day of month
        if month == 12:
            next_m = datetime.date(year + 1, 1, 1)
        else:
            next_m = datetime.date(year, month + 1, 1)
        end_dt = next_m - datetime.timedelta(days=1)
        end_date = end_dt.strftime("%Y-%m-%d")

        curr_overview = self.get_overview(start_date, end_date)

        # Prior month
        if month == 1:
            prev_year = year - 1
            prev_month = 12
        else:
            prev_year = year
            prev_month = month - 1
        prev_start = f"{prev_year:04d}-{prev_month:02d}-01"
        prev_end = (datetime.date(year, month, 1) - datetime.timedelta(days=1)).strftime("%Y-%m-%d")
        prev_overview = self.get_overview(prev_start, prev_end)

        prev_active = prev_overview["active_time"]
        curr_active = curr_overview["active_time"]
        delta_pct = round(((curr_active - prev_active) / prev_active * 100), 1) if prev_active > 0 else (100.0 if curr_active > 0 else 0.0)

        # Calendar heatmap cells
        days_in_month = end_dt.day
        calendar_cells = []
        for d in range(1, days_in_month + 1):
            d_str = f"{year:04d}-{month:02d}-{d:02d}"
            d_obj = datetime.date(year, month, d)
            trend_item = next((x for x in curr_overview["activity_trend"] if x["date"] == d_str), None)
            active_sec = trend_item["active_seconds"] if trend_item else 0
            calendar_cells.append({
                "day": d,
                "date": d_str,
                "weekday": d_obj.weekday(),  # 0=Monday, 6=Sunday
                "active_seconds": active_sec,
                "formatted": format_seconds(active_sec),
                "has_data": trend_item is not None and trend_item["has_data"]
            })

        return {
            "year": year,
            "month": month,
            "start_date": start_date,
            "end_date": end_date,
            "current": curr_overview,
            "previous": prev_overview,
            "delta_percent": delta_pct,
            "calendar_cells": calendar_cells
        }

    def get_yearly_analytics(self, year: int) -> Dict[str, Any]:
        """Calculates yearly trend (12 months) and top applications."""
        start_date = f"{year:04d}-01-01"
        end_date = f"{year:04d}-12-31"

        overview = self.get_overview(start_date, end_date)

        # Monthly series
        monthly_series = []
        month_rows = self.reader.query("""
            SELECT 
                CAST(strftime('%m', start_time) AS INTEGER) as m,
                COALESCE(SUM(CASE WHEN is_locked = 0 THEN duration_seconds ELSE 0 END), 0) as active_dur,
                COALESCE(SUM(duration_seconds), 0) as online_dur,
                COUNT(DISTINCT date(start_time)) as days_recorded
            FROM window_activities
            WHERE strftime('%Y', start_time) = ?
            GROUP BY m
            ORDER BY m ASC;
        """, (str(year),))

        m_map = {r["m"]: r for r in month_rows}
        month_names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

        for m_idx, m_name in enumerate(month_names, 1):
            item = m_map.get(m_idx)
            has_data = item is not None and item["days_recorded"] > 0
            active_sec = item["active_dur"] if item else 0
            monthly_series.append({
                "month": m_idx,
                "month_name": m_name,
                "active_seconds": active_sec,
                "active_hours": round(active_sec / 3600.0, 1),
                "online_seconds": item["online_dur"] if item else 0,
                "days_recorded": item["days_recorded"] if item else 0,
                "has_data": has_data
            })

        # Most active month
        active_months = [m for m in monthly_series if m["has_data"]]
        most_active_month = max(active_months, key=lambda x: x["active_seconds"]) if active_months else None

        return {
            "year": year,
            "overview": overview,
            "monthly_series": monthly_series,
            "most_active_month": most_active_month
        }

    def get_all_time_analytics(self) -> Dict[str, Any]:
        """Examines complete historical dataset from earliest to latest record."""
        bounds = self.get_date_bounds()
        min_date = bounds["min_date"]
        max_date = bounds["max_date"]

        overview = self.get_overview(min_date, max_date)

        # All-time top 10 apps
        top_apps_all = self.reader.query("""
            SELECT app_name, app_id, category, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE is_locked = 0
            GROUP BY app_name
            ORDER BY total_dur DESC
            LIMIT 10;
        """)

        # All-time top 10 categories
        top_cats_all = self.reader.query("""
            SELECT category, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE is_locked = 0
            GROUP BY category
            ORDER BY total_dur DESC
            LIMIT 10;
        """)

        # All-time activity heatmap (all tracked days grouped into weeks)
        all_days = self.reader.query("""
            SELECT 
                date(start_time) as d,
                COALESCE(SUM(CASE WHEN is_locked = 0 THEN duration_seconds ELSE 0 END), 0) as active_dur
            FROM window_activities
            GROUP BY d
            ORDER BY d ASC;
        """)

        heatmap = []
        for r in all_days:
            heatmap.append({
                "date": r["d"],
                "active_seconds": r["active_dur"],
                "formatted": format_seconds(r["active_dur"])
            })

        return {
            "earliest_date": min_date,
            "latest_date": max_date,
            "total_tracked_days": bounds["tracked_days"],
            "total_records": bounds["total_records"],
            "overview": overview,
            "top_apps": [
                {
                    "name": r["app_name"],
                    "app_id": r["app_id"],
                    "category": r["category"],
                    "duration": r["total_dur"],
                    "formatted": format_seconds(r["total_dur"])
                } for r in top_apps_all
            ],
            "top_categories": [
                {
                    "category": r["category"],
                    "name": CANONICAL_CATEGORIES.get(r["category"], {}).get("name", r["category"]),
                    "icon": CANONICAL_CATEGORIES.get(r["category"], {}).get("icon", "📌"),
                    "duration": r["total_dur"],
                    "formatted": format_seconds(r["total_dur"])
                } for r in top_cats_all
            ],
            "heatmap": heatmap
        }

    def get_applications_list(self, search: str = "", category_filter: str = "all", sort_by: str = "duration", sort_desc: bool = True) -> List[Dict[str, Any]]:
        """List of all tracked applications with usage, session counts, avg & longest session."""
        sql = """
            SELECT 
                app_name,
                app_id,
                category,
                SUM(duration_seconds) as total_dur,
                COUNT(*) as session_count,
                MAX(duration_seconds) as longest_session,
                AVG(duration_seconds) as avg_session,
                MIN(start_time) as first_seen,
                MAX(end_time) as last_seen
            FROM window_activities
            WHERE is_locked = 0
        """
        params = []
        if search:
            sql += " AND (app_name LIKE ? OR app_id LIKE ?)"
            params.extend([f"%{search}%", f"%{search}%"])
        if category_filter and category_filter != "all":
            sql += " AND category = ?"
            params.append(category_filter)

        sql += " GROUP BY app_name"

        # Sorting
        sort_column = "total_dur"
        if sort_by == "sessions":
            sort_column = "session_count"
        elif sort_by == "name":
            sort_column = "app_name COLLATE NOCASE"
        elif sort_by == "recent":
            sort_column = "last_seen"

        direction = "DESC" if sort_desc else "ASC"
        sql += f" ORDER BY {sort_column} {direction};"

        rows = self.reader.query(sql, tuple(params))
        total_active_all = sum(r["total_dur"] for r in rows) if rows else 1

        apps = []
        for r in rows:
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])
            dur = r["total_dur"]
            apps.append({
                "app_name": r["app_name"],
                "app_id": r["app_id"],
                "category": ck,
                "category_name": cinfo["name"],
                "icon": cinfo["icon"],
                "color": cinfo["color"],
                "total_seconds": dur,
                "total_formatted": format_seconds(dur),
                "active_percent": round((dur / total_active_all * 100), 1),
                "session_count": r["session_count"],
                "avg_session_seconds": int(r["avg_session"] or 0),
                "avg_session_formatted": format_seconds(int(r["avg_session"] or 0)),
                "longest_session_seconds": r["longest_session"],
                "longest_session_formatted": format_seconds(r["longest_session"]),
                "first_seen": r["first_seen"][:10] if r["first_seen"] else "N/A",
                "last_seen": r["last_seen"][:10] if r["last_seen"] else "N/A"
            })
        return apps

    def get_application_detail(self, app_name: str) -> Dict[str, Any]:
        """Deep dive into a single application's historical usage and window titles."""
        # Top window titles
        win_rows = self.reader.query("""
            SELECT window_title, SUM(duration_seconds) as total_dur, COUNT(*) as sessions
            FROM window_activities
            WHERE app_name = ? AND is_locked = 0
            GROUP BY window_title
            ORDER BY total_dur DESC
            LIMIT 20;
        """, (app_name,))

        # Daily usage series (last 30 active days)
        daily_rows = self.reader.query("""
            SELECT date(start_time) as d, SUM(duration_seconds) as total_dur
            FROM window_activities
            WHERE app_name = ? AND is_locked = 0
            GROUP BY d
            ORDER BY d ASC;
        """, (app_name,))

        return {
            "app_name": app_name,
            "window_titles": [
                {
                    "title": r["window_title"] or "Untitled",
                    "duration": r["total_dur"],
                    "formatted": format_seconds(r["total_dur"]),
                    "sessions": r["sessions"]
                } for r in win_rows
            ],
            "daily_trend": [
                {
                    "date": r["d"],
                    "seconds": r["total_dur"],
                    "formatted": format_seconds(r["total_dur"])
                } for r in daily_rows
            ]
        }

    def get_categories_list(self) -> List[Dict[str, Any]]:
        """List of categories with usage statistics and associated top apps."""
        cat_rows = self.reader.query("""
            SELECT 
                category,
                SUM(duration_seconds) as total_dur,
                COUNT(DISTINCT app_name) as app_count,
                COUNT(*) as session_count
            FROM window_activities
            WHERE is_locked = 0
            GROUP BY category
            ORDER BY total_dur DESC;
        """)

        total_active_all = sum(r["total_dur"] for r in cat_rows) if cat_rows else 1

        cats = []
        for r in cat_rows:
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])
            dur = r["total_dur"]

            # Top apps in this category
            top_apps = self.reader.query("""
                SELECT app_name, SUM(duration_seconds) as app_dur
                FROM window_activities
                WHERE category = ? AND is_locked = 0
                GROUP BY app_name
                ORDER BY app_dur DESC
                LIMIT 5;
            """, (ck,))

            cats.append({
                "category": ck,
                "name": cinfo["name"],
                "icon": cinfo["icon"],
                "color": cinfo["color"],
                "total_seconds": dur,
                "total_formatted": format_seconds(dur),
                "active_percent": round((dur / total_active_all * 100), 1),
                "app_count": r["app_count"],
                "session_count": r["session_count"],
                "top_apps": [
                    {"name": a["app_name"], "duration": a["app_dur"], "formatted": format_seconds(a["app_dur"])}
                    for a in top_apps
                ]
            })
        return cats

    def get_historical_records(
        self,
        search: str = "",
        app_filter: str = "",
        category_filter: str = "all",
        start_date: str = "",
        end_date: str = "",
        sort_by: str = "start_time",
        sort_desc: bool = True,
        page: int = 1,
        page_size: int = 50
    ) -> Dict[str, Any]:
        """Paginated query for searching and inspecting historical records."""
        where_clauses = ["1=1"]
        params = []

        if search:
            where_clauses.append("(app_name LIKE ? OR window_title LIKE ?)")
            params.extend([f"%{search}%", f"%{search}%"])
        if app_filter:
            where_clauses.append("app_name = ?")
            params.append(app_filter)
        if category_filter and category_filter != "all":
            where_clauses.append("category = ?")
            params.append(category_filter)
        if start_date:
            where_clauses.append("date(start_time) >= date(?)")
            params.append(start_date)
        if end_date:
            where_clauses.append("date(start_time) <= date(?)")
            params.append(end_date)

        where_sql = " AND ".join(where_clauses)

        # Count total matching
        count_row = self.reader.query_one(f"SELECT COUNT(*) as c FROM window_activities WHERE {where_sql}", tuple(params))
        total_count = count_row["c"] if count_row else 0
        total_pages = max(1, (total_count + page_size - 1) // page_size)

        # Valid sort columns
        allowed_sorts = {
            "start_time": "start_time",
            "duration": "duration_seconds",
            "app": "app_name COLLATE NOCASE",
            "category": "category"
        }
        order_col = allowed_sorts.get(sort_by, "start_time")
        direction = "DESC" if sort_desc else "ASC"
        offset = (page - 1) * page_size

        sql = f"""
            SELECT id, start_time, end_time, duration_seconds, app_name, app_id, window_title, category, is_locked, is_idle
            FROM window_activities
            WHERE {where_sql}
            ORDER BY {order_col} {direction}
            LIMIT ? OFFSET ?;
        """
        exec_params = list(params) + [page_size, offset]
        rows = self.reader.query(sql, tuple(exec_params))

        records = []
        for r in rows:
            ck = r["category"]
            cinfo = CANONICAL_CATEGORIES.get(ck, CANONICAL_CATEGORIES["other"])
            dur = r["duration_seconds"]
            records.append({
                "id": r["id"],
                "date": r["start_time"][:10],
                "start_time": r["start_time"],
                "end_time": r["end_time"],
                "duration_seconds": dur,
                "duration_formatted": format_seconds(dur),
                "app_name": r["app_name"],
                "app_id": r["app_id"],
                "window_title": r["window_title"] or "Untitled",
                "category": ck,
                "category_name": cinfo["name"],
                "icon": cinfo["icon"],
                "color": cinfo["color"],
                "is_locked": bool(r["is_locked"]),
                "is_idle": bool(r["is_idle"])
            })

        return {
            "page": page,
            "page_size": page_size,
            "total_count": total_count,
            "total_pages": total_pages,
            "records": records
        }
