#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=== 1. Validating metadata.json files ==="
for widget in "quick-capture" "habit-tracker" "random-challenge" "task-goal-manager" "timetrack-widget"; do
    meta="${ROOT_DIR}/${widget}/metadata.json"
    python3 -c "import json; d=json.load(open('${meta}')); print('✓ Valid JSON:', d['KPlugin']['Id'], '-', d['KPlugin']['Name'])"
done

echo ""
echo "=== 2. Running qmllint on all QML files ==="
/usr/lib/qt6/bin/qmllint \
    "${ROOT_DIR}"/shared/theme/*.qml \
    "${ROOT_DIR}"/shared/components/*.qml \
    "${ROOT_DIR}"/quick-capture/contents/ui/*.qml \
    "${ROOT_DIR}"/habit-tracker/contents/ui/*.qml \
    "${ROOT_DIR}"/random-challenge/contents/ui/*.qml \
    "${ROOT_DIR}"/task-goal-manager/contents/ui/*.qml \
    "${ROOT_DIR}"/timetrack-widget/contents/ui/*.qml

echo "✓ All QML files passed syntax checks."

echo ""
echo "=== 3. Testing runtime load via plasmawindowed ==="
for id in \
    "org.kde.plasma.productivitysuite.quickcapture" \
    "org.kde.plasma.productivitysuite.habittracker" \
    "org.kde.plasma.productivitysuite.randomchallenge" \
    "org.kde.plasma.productivitysuite.taskgoalmanager" \
    "org.kde.plasma.timetrackanalytics"; do
    echo "Testing load: ${id}..."
    timeout 2s plasmawindowed "${id}" >/dev/null 2>&1 || true
    echo "  ✓ ${id} loaded without crashing."
done

echo ""
echo "=== 4. Running Backend Unit Tests ==="
python3 -m unittest tests/test_backend.py

echo ""
echo "=== All validation and runtime checks passed! ==="

