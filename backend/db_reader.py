#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Strict read-only database reader for desktop-timetracker.
Guarantees zero modifications (PRAGMA query_only = ON, ?mode=ro).
"""

import sqlite3
import subprocess
from pathlib import Path
from typing import Optional, List, Dict, Any

DEFAULT_DB_PATH = Path.home() / ".local" / "share" / "timetracker" / "timetracker.db"


class TimeTrackDBReader:
    """Manages read-only connections and verification for timetracker.db."""

    def __init__(self, db_path: Optional[Path] = None):
        self.db_path = Path(db_path) if db_path else DEFAULT_DB_PATH

    def exists(self) -> bool:
        return self.db_path.exists() and self.db_path.stat().st_size > 0

    def get_connection(self) -> sqlite3.Connection:
        """Returns a strict read-only SQLite connection."""
        if not self.exists():
            raise FileNotFoundError(f"TimeTrack database not found at {self.db_path}")

        # Open in read-only mode via URI
        uri = f"file:{self.db_path.resolve()}?mode=ro"
        conn = sqlite3.connect(uri, uri=True, check_same_thread=False)
        conn.row_factory = sqlite3.Row
        # Extra layer of defense against accidental writes
        conn.execute("PRAGMA query_only = ON;")
        return conn

    def query(self, sql: str, params: tuple = ()) -> List[Dict[str, Any]]:
        """Executes a read-only query and returns a list of dictionaries."""
        with self.get_connection() as conn:
            cur = conn.execute(sql, params)
            rows = cur.fetchall()
            return [dict(r) for r in rows]

    def query_one(self, sql: str, params: tuple = ()) -> Optional[Dict[str, Any]]:
        """Executes a read-only query and returns a single dictionary or None."""
        with self.get_connection() as conn:
            cur = conn.execute(sql, params)
            row = cur.fetchone()
            return dict(row) if row else None

    @staticmethod
    def is_service_active() -> bool:
        """Checks if desktop-timetracker.service is active via systemctl."""
        try:
            res = subprocess.run(
                ["systemctl", "--user", "is-active", "desktop-timetracker.service"],
                capture_output=True,
                text=True,
                timeout=2.0
            )
            return res.stdout.strip() == "active"
        except Exception:
            return False

