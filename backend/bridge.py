#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PyQt6 QObject bridge connecting QML UI to TimeTrackQueryService and TimeTrackExportService.
All data is serialized as JSON strings for seamless, zero-copy QML consumption.
"""

import json
from pathlib import Path
from PyQt6.QtCore import QObject, pyqtSlot, pyqtSignal, QTimer, QThread
from .query_service import TimeTrackQueryService
from .export_service import TimeTrackExportService


class TimeTrackBridge(QObject):
    # Signals to notify QML
    liveStatusChanged = pyqtSignal(str)
    exportCompleted = pyqtSignal(bool, str)
    dataLoaded = pyqtSignal(str, str)  # section, json_payload

    def __init__(self, query_service=None, parent=None):
        super().__init__(parent)
        self.query_service = query_service or TimeTrackQueryService()
        self.export_service = TimeTrackExportService(self.query_service)

        # Periodic live status timer (every 5 seconds)
        self.live_timer = QTimer(self)
        self.live_timer.timeout.connect(self._poll_live_status)
        self.live_timer.start(5000)

    def _poll_live_status(self):
        try:
            status = self.query_service.get_live_status()
            self.liveStatusChanged.emit(json.dumps(status))
        except Exception as e:
            pass

    @pyqtSlot(result=str)
    def getLiveStatus(self) -> str:
        status = self.query_service.get_live_status()
        return json.dumps(status)

    @pyqtSlot(result=str)
    def getDateBounds(self) -> str:
        bounds = self.query_service.get_date_bounds()
        return json.dumps(bounds)

    @pyqtSlot(str, str, result=str)
    def getOverview(self, start_date: str, end_date: str) -> str:
        data = self.query_service.get_overview(start_date, end_date)
        return json.dumps(data)

    @pyqtSlot(str, result=str)
    def getDailyAnalytics(self, target_date: str) -> str:
        data = self.query_service.get_daily_analytics(target_date)
        return json.dumps(data)

    @pyqtSlot(str, str, str, result=str)
    def getTimelineBlocks(self, target_date: str, app_filter: str, category_filter: str) -> str:
        data = self.query_service.get_timeline_blocks(target_date, app_filter, category_filter)
        return json.dumps(data)

    @pyqtSlot(str, str, int, result=str)
    def getMultiDayTimeline(self, start_date: str, end_date: str, limit_days: int) -> str:
        data = self.query_service.get_multi_day_timeline(start_date, end_date, limit_days)
        return json.dumps(data)

    @pyqtSlot(str, result=str)
    def getWeeklyAnalytics(self, end_date: str) -> str:
        data = self.query_service.get_weekly_analytics(end_date)
        return json.dumps(data)

    @pyqtSlot(int, int, result=str)
    def getMonthlyAnalytics(self, year: int, month: int) -> str:
        data = self.query_service.get_monthly_analytics(year, month)
        return json.dumps(data)

    @pyqtSlot(int, result=str)
    def getYearlyAnalytics(self, year: int) -> str:
        data = self.query_service.get_yearly_analytics(year)
        return json.dumps(data)

    @pyqtSlot(result=str)
    def getAllTimeAnalytics(self) -> str:
        data = self.query_service.get_all_time_analytics()
        return json.dumps(data)

    @pyqtSlot(str, str, str, bool, result=str)
    def getApplicationsList(self, search: str, category_filter: str, sort_by: str, sort_desc: bool) -> str:
        data = self.query_service.get_applications_list(search, category_filter, sort_by, sort_desc)
        return json.dumps(data)

    @pyqtSlot(str, result=str)
    def getApplicationDetail(self, app_name: str) -> str:
        data = self.query_service.get_application_detail(app_name)
        return json.dumps(data)

    @pyqtSlot(result=str)
    def getCategoriesList(self) -> str:
        data = self.query_service.getCategoriesList() if hasattr(self.query_service, "getCategoriesList") else self.query_service.get_categories_list()
        return json.dumps(data)

    @pyqtSlot(str, str, str, str, str, str, bool, int, int, result=str)
    def getHistoricalRecords(
        self,
        search: str,
        app_filter: str,
        category_filter: str,
        start_date: str,
        end_date: str,
        sort_by: str,
        sort_desc: bool,
        page: int,
        page_size: int
    ) -> str:
        data = self.query_service.get_historical_records(
            search=search,
            app_filter=app_filter,
            category_filter=category_filter,
            start_date=start_date,
            end_date=end_date,
            sort_by=sort_by,
            sort_desc=sort_desc,
            page=page,
            page_size=page_size
        )
        return json.dumps(data)

    @pyqtSlot(str, str, str, str, result=str)
    def exportData(self, fmt: str, start_date: str, end_date: str, target_path: str) -> str:
        try:
            fmt_lower = fmt.lower()
            dest = Path(target_path) if target_path else Path.home() / "Documents" / f"TimeTrack_{start_date}_{end_date}.{fmt_lower}"
            if fmt_lower == "csv":
                self.export_service.export_csv(start_date, end_date, dest)
            elif fmt_lower == "json":
                self.export_service.export_json(start_date, end_date, dest)
            elif fmt_lower in ["md", "markdown"]:
                self.export_service.export_markdown(start_date, end_date, dest)
            else:
                return f"Unsupported format: {fmt}"
            self.exportCompleted.emit(True, str(dest))
            return f"Exported successfully to {dest}"
        except Exception as e:
            self.exportCompleted.emit(False, str(e))
            return f"Export error: {e}"
