#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Automated unit tests for TimeTrack Visual Analytics backend.
"""

import unittest
import json
import sqlite3
from pathlib import Path
from backend.db_reader import TimeTrackDBReader
from backend.query_service import TimeTrackQueryService, format_seconds, CANONICAL_CATEGORIES
from backend.export_service import TimeTrackExportService


class TestTimeTrackBackend(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.reader = TimeTrackDBReader()
        cls.query_service = TimeTrackQueryService(cls.reader)
        cls.export_service = TimeTrackExportService(cls.query_service)

    def test_database_exists(self):
        self.assertTrue(self.reader.exists(), "timetracker.db must exist and not be empty")

    def test_read_only_enforcement(self):
        conn = self.reader.get_connection()
        # Attempting an insert or table creation must raise sqlite3.OperationalError
        with self.assertRaises(sqlite3.OperationalError):
            conn.execute("CREATE TABLE test_write_block (id INT);")
        with self.assertRaises(sqlite3.OperationalError):
            conn.execute("UPDATE window_activities SET duration_seconds = 0 WHERE id = 1;")
        conn.close()

    def test_date_bounds(self):
        bounds = self.query_service.get_date_bounds()
        self.assertIn("min_date", bounds)
        self.assertIn("max_date", bounds)
        self.assertEqual(bounds["min_date"], "2026-10-05")
        self.assertGreaterEqual(bounds["tracked_days"], 35)

    def test_today_metrics_consistency(self):
        target_date = "2026-11-14"
        ov = self.query_service.get_overview(target_date, target_date)
        self.assertEqual(ov["start_date"], target_date)
        self.assertEqual(ov["end_date"], target_date)
        self.assertGreater(ov["active_time"], 0)
        self.assertGreater(ov["online_time"], 0)
        self.assertEqual(ov["active_time"] + ov["locked_time"], ov["online_time"])
        self.assertIsInstance(ov["category_distribution"], list)
        self.assertIsInstance(ov["top_apps"], list)

    def test_daily_timeline_blocks(self):
        target_date = "2026-11-14"
        blocks = self.query_service.get_timeline_blocks(target_date)
        self.assertGreater(len(blocks), 0)
        first_b = blocks[0]
        self.assertIn("start_minute", first_b)
        self.assertIn("duration_minutes", first_b)
        self.assertIn("app_name", first_b)
        self.assertIn("category", first_b)

    def test_applications_list(self):
        apps = self.query_service.get_applications_list(sort_by="duration")
        self.assertGreater(len(apps), 10)
        top = apps[0]
        self.assertIn("app_name", top)
        self.assertIn("total_seconds", top)
        self.assertGreater(top["total_seconds"], 0)

    def test_categories_list(self):
        cats = self.query_service.get_categories_list()
        self.assertGreater(len(cats), 5)
        cat_keys = [c["category"] for c in cats]
        self.assertIn("browsing", cat_keys)
        self.assertIn("media", cat_keys)

    def test_exports(self):
        csv_str = self.export_service.export_csv("2026-11-14", "2026-11-14")
        self.assertIn("start_time", csv_str)
        self.assertIn("Zen Browser", csv_str)

        json_str = self.export_service.export_json("2026-11-14", "2026-11-14")
        payload = json.loads(json_str)
        self.assertIn("overview", payload)
        self.assertIn("records", payload)

        md_str = self.export_service.export_markdown("2026-11-14", "2026-11-14")
        self.assertIn("# 📊 TimeTrack Analytics Report", md_str)


if __name__ == "__main__":
    unittest.main()
